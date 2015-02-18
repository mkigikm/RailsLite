module Phase9
  module RouteHelper
    UNSAFE_CHARS = {
      "<" => "&gt;" ,
      ">" => "&lt;" ,
      "&" => "&amp;",
      "'" => "&apos",
      '"' => "&quot;"
    }

    def html_escape(string)
      string.dup.tap do |string|
        UNSAFE_CHARS.each do |char, entity|
          string.gsub!(char, entity)
        end
      end
    end

    define_method(:h) { |string| html_escape(string) }

    def link_to(body, url)
      <<-HTML
      <a href="#{h(url)}">#{h(body)}</a>
      HTML
    end

    def button_to(name, url)
      <<-HTML
      <form class="" action="#{h(url)}" method="post">
        <input type="hidden" name="authenticity_token" value="#{form_authenticity_token}">
        <button>#{h(name)}</button>
      </form>
      HTML
    end

    def form_authenticity_token
      session["authenticity_token"]
    end
  end
end
