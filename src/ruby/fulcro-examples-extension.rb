# A block macro that embeds a Fulcro example into the output document
#
# Usage
#
#   $example$ "Using External React Libraries", "victory_id", "./src/victory_example.cljs"]

##############
#   Which in turn gets converted into
##############
=begin

.[[UsingExternalReactLibraries]]<<UsingExternalReactLibraries,Using External React Libraries>>
====
++++
<button class="inspector" onClick="book.main.focus('victory-id')">Focus Inspector</button>
<div class="short narrow example" id="victory-id"></div>
<br/>
++++
[source,clojure,role="source"]
----
include::src/book/book/ui/victory_example.cljs[]
----
====

=end


##############
# Extension code
##############



require 'asciidoctor/extensions'

include Asciidoctor




def create_asciidoc_block example_name, example_id, example_source
  anchor_name = example_name.gsub(/\s+/, '')
  return <<-EOF
.[[#{anchor_name}]]<<#{anchor_name},#{example_name}>>
====

++++
<button class="inspector" onClick="book.main.focus('#{example_id}')">Focus Inspector</button>
<div class="short narrow example" id="#{example_id}"></div>
<br/>
++++

[source,clojure,role="source"]
-----
include::#{example_source}[]
-----

====
EOF
end

class FulcroPreprocessor < Extensions::Preprocessor
  def process document, reader
    return reader if reader.eof?
    result = [];

    reader.read_lines.each do |line|
      if(line.include? '$example$')
        parameters = line.split("$")[2]
        example_name = parameters.split(",")[0].strip()
        example_id = parameters.split(",")[1].strip()
        example_source =  parameters.split(",")[2].strip()
        example_block = create_asciidoc_block(example_name, example_id, example_source)
        new_lines = example_block.split("\n")
        new_lines.each do |line|
          result.push(line)
        end
      else
        result.push(line)
      end
    end
    reader.unshift_lines(result)
    reader
  end
end
