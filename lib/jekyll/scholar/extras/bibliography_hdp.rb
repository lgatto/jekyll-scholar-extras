module Jekyll
  class Scholar

    class BibliographyHDPTag < Liquid::Tag
      include Scholar::Utilities
      include ScholarExtras::Utilities
  
      def initialize(tag_name, arguments, tokens)
        super

        @config = Scholar.defaults.dup
        @bibtex_file = arguments.strip
      end

      def render(context)
        set_context_to context

         year_section = ''
         opts = ['@*[public!=no]']

#references = public_entries.map do |entry|
         references = get_entries(opts).map do |entry|
          reference = ''
          ref = ''

          ref = CiteProc.process entry.to_citeproc, :style => config['style'],
            :locale => config['locale'], :format => 'html'
          content_tag :span, ref, :id => entry.key

          if entry.field?(:year)
            if (year_section != entry[:year])
              reference << "<h1>"
              reference << entry[:year].to_s
              reference << "</h1>"
              year_section = entry[:year]
            end
          end 

          reference << ref
          if generate_details?
           reference << "<br />"
           reference << link_to(details_link_for(entry), config['details_link'])
           reference << "."
          end

          if entry.field?(:pdflink1) or entry.field?(:slides)
            reference << "<b> Downloads: </b>" 
          end 

          if entry.field?(:pdflink1)
#if config['pdf_logo'] 
#              puts "pdf_logo"
#              reference << "<img class=\"alignleft\" title=\"pdf\" src=" + config['pdf_logo'] +  "alt=\"\" width=\"50\" height=\"30\" />"
#            else
              reference << "<a href=\""  + entry[:pdflink1].to_s + "\">PDF</a>"
#            end

          end
          
          if entry.field?(:slides)
#            if config['ppt_logo'] 
#              puts "ppt_logo"
#              reference << "<img class=\"alignleft\" title=\"ppt\" src=" + config['ppt_logo'] +  "alt=\"\" width=\"50\" height=\"30\" />"
#            else
              reference << "<a href=\""  + entry[:slides].to_s + "\">, Slides</a>"
#            end
          end

          content_tag :br, reference
        end

        references.join("\n")
#content_tag :ul, references.join("\n")
#content_tag :li, reference
      end
      
    end
    
  end
end

Liquid::Template.register_tag('bibliography_hdp', Jekyll::Scholar::BibliographyHDPTag)
