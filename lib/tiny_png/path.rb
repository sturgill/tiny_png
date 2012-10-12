module TinyPng
  class Path
    #
    # Create a TinyPng::Path object and optionally add .png paths to the
    # show list (also transverses directories).
    #
    def initialize *show
      @show = TinyPng::Path.get_all show
      @blacklist = []
    end
    
    #
    # Add paths to the list (also transverses directories).
    #
    def add *list
      @show = (@show + TinyPng::Path.get_all(list)).uniq
    end
    
    #
    # Add paths to the list (also transverses directories). The blacklist
    # supercedes the add list, such that any path added to the blacklist will
    # not show up in the final compilation.
    #
    def blacklist *list
      @blacklist = (@blacklist + TinyPng::Path.get_all(list)).uniq
    end
    
    #
    # Remove paths from the list (also transverses directories).
    #
    def remove_from_list *list
      @show = @show - TinyPng::Path.get_all(list)
    end
    
    #
    # Remove paths from the blacklist (also transverses directories).
    #
    def remove_from_blacklist *list
      @blacklist = @blacklist - TinyPng::Path.get_all(list)
    end
    
    #
    # Return the full list of paths, minus anything in the blacklist.
    #
    def list
      @show.uniq - @blacklist
    end
    
    #
    # Get all .png path names from the passed-in files and directories.
    #
    def self.get_all *list
      list.flatten.uniq.collect do |path|
        if path.is_a?(TinyPng::Path)
          path.list
        else
          if File.directory?(path)
            Dir.glob("#{path.gsub(/\/$/,'')}/**/*.png")
          else
            path.downcase.match(/\.png$/) ? path : nil
          end
        end
      end.flatten.uniq.compact
    end
  end
end