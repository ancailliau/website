module Waw
  class StaticController < ::Waw::Controller
    class WawAccess
      class Match
        
        def folder_stylesheets(where, root = wawaccess.root.folder)
          Dir[File.join(where, "css", "*.css")].sort.collect{|file| file[root.length..-1]} 
        end
        
        def folder_scripts(where, root = wawaccess.root.folder)
          Dir[File.join(where, "js", "*.js")].sort.collect{|file| file[root.length..-1]}
        end
        
        def wlang_context(served = served_file, root = wawaccess.root.folder)
          served_folder = File.dirname(File.expand_path(served))

          # Create a first basic context
          context = {:base           => "#{config.web_base}#{req_path}",
                     :normalized_url => req_path,
                     :referer        => request.referer,
                     :page_name      => File.basename(req_path),
                     :title          => config.application_title}
                     
          # Find the css and js files
          current_folder = served_folder
          stylesheets, scripts, classes = [], [], []
          side_file = nil
          until current_folder == File.dirname(root)
            # find stylesheets and scripts
            stylesheets.unshift folder_stylesheets(current_folder)
            scripts.unshift folder_scripts(current_folder)

            if side_file.nil? and File.exists?(File.join(current_folder, "side.wtpl"))
              side_file = File.join(current_folder, "side.wtpl")
            end

            # extend css classes
            classes << File.basename(current_folder)
      
            # continue
            current_folder = File.dirname(current_folder)
          end
    
          # Complete the context
          context.merge!(:stylesheets    => stylesheets.flatten,
                         :scripts        => scripts.flatten,
                         :classes        => classes,
                         :side_file      => side_file)
    
          context
        end
        
      end # class Match
    end # class WawAccess
  end # class StaticController
end # module Waw
