require "fileutils"
here = File.dirname(__FILE__)
from = File.join(here, '..', '..', 'admin', 'js', 'acmscw_generated.js')
to   = File.join(here, '..', '..', 'views', 'js')
FileUtils.cp(from, to) 