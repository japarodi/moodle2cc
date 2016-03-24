module Moodle2CC::Moodle2
  class Parsers::LtiParser
    include Parsers::ParserHelper

    LTI_XML = 'lti.xml'
    LTI_MODULE_NAME = 'lti'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_dirs = activity_directories(@backup_dir, LTI_MODULE_NAME)
      activity_dirs.map { |dir| parse_lti(dir) }
    end

    private

    def parse_lti(dir)
      lti = Models::Lti.new
      activity_dir = File.join(@backup_dir, dir)
      File.open(File.join(activity_dir, LTI_XML)) do |f|
        lti_xml = Nokogiri::XML(f)
        lti.id                  = lti_xml.at_xpath('/activity/lti/@id').value
        lti.module_id           = lti_xml.at_xpath('/activity/@moduleid').value
        lti.name                = parse_text(lti_xml, '/activity/lti/name')
        lti.url                 = parse_text(lti_xml, '/activity/lti/toolurl')
        lti.external_tool_url   = parse_text(lti_xml, '/activity/lti/toolurl')
        lti.grade               = parse_text(lti_xml, '/activity/lti/grade')
        if(lti.grade != nill && lti.grade != '0') 
          lti.external_tool_submission = '1'
          if(parse_text(lti_xml, '/activity/lti/launchcontainer' == '4'))
            lti.external_tool_new_tab = 'true'
          else
            lti.external_tool_new_tab = 'false'
          end
        else
        end                
    end
    
      if(lti.external_tool_submission = '1') 
        parse_module(activity_dir, assignment)
        assignment
      else
        parse_module(activity_dir, lti)
        lti      
      end
   end
end