class Company < ActiveRecord::Base
    has_many :drivers
    has_attached_file :logo, 
        :path => ":rails_root/public/images/:class/:id/:basename_:style.:extension",
        :url => "/images/:class/:id/:basename_:style.:extension",
        :default_style => :preview,
        :styles => {
            :thumb    => ['100x100^',  :jpg, :quality => 70],
            :preview  => ['300x300^',  :jpg, :quality => 70],
            :large    => ['600>',      :jpg, :quality => 70]
        }

    validates_attachment :logo,
        :presence => true,
        :size => { :in => 0..10.megabytes },
        :content_type => { :content_type => /^image\/(jpeg|png|gif|tiff)$/ }


end
