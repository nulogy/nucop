module Nucop
  module Helpers
    module FilePathHelper
      def acceptance_or_spec_file?(filepath)
        Pathname.new(filepath).fnmatch?(File.join("**", "{spec,acceptance}", "**"), File::FNM_EXTGLOB)
      end

      def support_file?(filepath)
        Pathname.new(filepath).fnmatch?(File.join("**", "support", "**"), File::FNM_EXTGLOB)
      end
    end
  end
end
