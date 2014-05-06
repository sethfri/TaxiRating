class StaticPagesController < ApplicationController
  before_action :authenticate_user!

  def overview
  end

  def get_historical_company_ratings
      # First, we will figure out a good interval to use to display the graph
      # We will do the smaller of the age of the oldest rating/6 and 1 month
      
      interval_by_oldest = (Time.now - Rating.first(:order => 'created_at asc').created_at)/6
      interval = [1.month, interval_by_oldest].min
      puts "interval is #{interval}"
     
      # Figure out historical company ratings by working back from the current 
      # average rating and adjust the company rating accordingly
      # Algorithm:
      #     Get all companies and their average ratings
      #     For each company,
      #         For all increments that will be graphed:
      #             Get all ratings in that interval
      #             Change the prev average rating of the company
      #               given the average ratings in the interval
      
      @historical_data = []
      company_hist_data = {}

      companies = Company.all.index_by(&:id).clone

      companies.each do |key, c|
          company_hist_data['name'] = c.name
          company_hist_data['data'] = {}

          (1..6).each do |m| #For the last six months
              sum_int_rat = 0 #average rating over the last interval
              int_rat_cnt = 0 #rating count over the last interval

              ratings = Rating.where(:created_at => 
                                     (Time.now - m*interval)..(Time.now - (m-1)*interval))
              ratings.each do |r|
                  if r.driver.company_id == key
                    int_rat_cnt += 1
                    sum_int_rat += r.rating
                  end
              end

              # Figure out the avg rating at time 'm'
              n = c.total_ratings
              if n != 0 and n != int_rat_cnt then
                  c.average_rating = (c.average_rating * n - sum_int_rat)/(n-int_rat_cnt) || 0
                  c.total_ratings = n - int_rat_cnt

                  company_hist_data['data'][(Time.now - m*interval)] = c.average_rating
              else
                  break;
              end
          end

          @historical_data.push(company_hist_data.clone) #This should be copied by value not reference
      end
  end

  def get_ratings
      length = params[:length].to_i || 5 #Entries to return
      sort_dir = params[:sort_dir] || "best" #Entries to return

      drivers = Driver.all.index_by(&:id)
      companies = Company.all.index_by(&:id)
      @drivers = {}
      @companies = {}

      drivers.each do |key, d| 
         d.total_ratings = 0
         d.average_rating = 0
      end

      companies.each do |k, c| 
         c.total_ratings = 0
         c.average_rating = 0
      end

      #Get the relevant ratings based on time
      puts "time is #{params[:time]}"
      case params[:time]
      when "day"
        @ratings = Rating.where(:created_at => 1.day.ago..Time.now)
      when "week"
        @ratings = Rating.where(:created_at => 1.week.ago..Time.now)
      when "month"
        @ratings = Rating.where(:created_at => 1.month.ago..Time.now)
      when "year"
        @ratings = Rating.where(:created_at => 1.year.ago..Time.now)
      when "all"
        @ratings = Rating.all
      end

      @ratings = @ratings.to_a

      @ratings.each do |r| 
          # Store drivers/companies with any ratings in the interval
          if @drivers[r.driver_id].nil?
            @drivers[r.driver_id] = drivers[r.driver_id]
          end

          @drivers[r.driver_id].average_rating += r.rating
          @drivers[r.driver_id].total_ratings += 1

          # Now the companies
          c_id = @drivers[r.driver_id].company_id
          if @companies[c_id].nil?
            @companies[c_id] = companies[c_id]
          end

          @companies[c_id].average_rating += r.rating
          @companies[c_id].total_ratings += 1
      end

      # Get the averages
      @drivers.each{ |k, d| d.average_rating /= d.total_ratings }
      @companies.each{ |k, c| c.average_rating /= c.total_ratings }

      # Convert to a sorted array
      @drivers = @drivers.values.sort_by{ |d| -d.average_rating }
      @companies = @companies.values.sort_by{ |c| -c.average_rating }

      if sort_dir == "worst"
          @drivers.reverse!
          @companies.reverse!
      end

      # Get the desired number
      @drivers = @drivers[0..length-1]
      @companies = @companies[0..length-1]
  end

  def import_export
    authorize! :import_export, Driver
    authorize! :import_export, Company
    authorize! :import_export, Rider
  end
  
end
