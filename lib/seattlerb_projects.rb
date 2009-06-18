
class SeattlerbProjects

  def projects
    layers = [ # mix of dependencies and priorities

              # most important: the foundation
              %w(hoe hoe-seattlerb),
              %w(ZenTest minitest minitest_tu_shim autotest-rails),

              # base libraries
              %w(RubyInline sexp_processor),
              %w(ParseTree ruby_parser ruby2ruby event_hook),

              # medium level - grouped by rough category
              %w(heckle flog flay vlad gauntlet),
              %w(ruby_to_c zenprofile wilson),
              %w(image_science png),

              # toys and soon to be more "serious"
              %w(ar_mailer imap_processor gmail_contacts imap_to_rss),
              %w(UPnP-ConnectionManager UPnP-MediaServer),
              %w(rails_analyzer_tools production_log_analyzer),
              %w(graph ZenWeb ZenGraph),
             ]

    hold = "
            Algometer AlgometerX metaruby Interpreters newri UNIX
            IMAPCleanse Inliner RubyAudit RingyDingy Satori Sphincter
            SyslogLogger UPnP UPnP-ContentDirectory UPnP-IGD
            action_profiler cached_model firebrigade firebrigade_api
            icanhasaudio mem_inspect memcache-client mogilefs-client
            rubicon scripts rbayes rubyholic stuporslow tinderbox
            seattlerb poopcode rdoc_osx_dictionary rubypan rometa
            drawr ograph ZenLibrary box_layout bfts rc-rest
            RailsRemoteControl yaccpuke ruby2smalltalk
            RubyInlineFortran ZenHacks zero2rails weight pkg_clean
            cocor
            ".scan(/\S+/)

    hold += layers.flatten

    # grab everything else we've missed and add them
    layers << Dir["*"].find_all { |d|
      d !~ /^\./ and File.directory?(d) and not hold.include? d
    }.sort_by { |d| -File.mtime(d).to_i }

    layers
  end
end

if $0 == __FILE__ then
  require 'pp'
  pp SeattlerbProjects.new.projects
end
