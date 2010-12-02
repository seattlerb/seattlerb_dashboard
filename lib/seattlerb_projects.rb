
class SeattlerbProjects

  ##
  # Returns nil if unreleased, false if the latest release is out of
  # date, true otherwise.

  def check_project project
    Dir.chdir project do
      ver = Dir["[0-9]*"].sort_by { |name| name.split(/\./).map { |n| n.to_i } }
      if ver.empty? then
        nil
      else
        ! system "diff -rq #{ver.last} dev | grep -q differ$"
      end
    end
  end

  def latest_version project
    Dir.chdir project do
      Dir["[0-9]*"].sort_by { |name| name.split(/\./).map { |n| n.to_i } }.last
    end
  end

  def current_version project
    version = nil

    dir = "#{project}/dev"
    return unless File.directory? dir

    Dir.chdir dir do
      files = File.read("Manifest.txt").split(/\n/)
      files.each do |file|
        begin
          version = File.read(file)[/VERSION = ([\"\'])([\d][\d\w\.]+)\1/, 2]
          break if version
        rescue
          # ignore it
        end
      end
    end

    version
  end

  def history_version project
    Dir.chdir "#{project}/dev" do
      File.read("History.txt").split(/\n/).first[/[\d\.]+/]
    end
  end

  def chdir_src
    src_dir = File.expand_path("~/Work/p4/zss/src")
    Dir.chdir src_dir
  end

  def projects
    chdir_src

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
            cocor ar_mailer Cocoa macports miniunit
            # if you won't write tests others can run, they won't get run.
            imap_processor gmail_contacts imap_to_rss
            macports
            ".gsub(/\s*\#.*/, '').scan(/\S+/)

    # TODO: trying to remove these from the above
    hold -= "
              IMAPCleanse Inliner RailsRemoteControl RingyDingy
              RubyAudit RubyInlineFortran Sphincter SyslogLogger UPnP
              UPnP-ContentDirectory UPnP-IGD ZenHacks action_profiler
              ar_mailer bfts box_layout cached_model cocor drawr
              firebrigade_api imap_processor imap_to_rss mem_inspect
              memcache-client metaruby rc-rest rdoc_osx_dictionary
              ruby2smalltalk rbayes rubyholic tinderbox
             ".scan(/\S+/)

    hold += layers.flatten

    # grab everything else we've missed and add them
    src_dir = File.expand_path("~/Work/p4/zss/src")
    Dir.chdir src_dir do
      layers << Dir["*"].find_all { |d|
        d !~ /^\./ and File.directory?(d) and not hold.include? d
      }.sort_by { |d| -File.mtime(d).to_i }
    end

    layers.last << layers.last.delete("seattlerb_dashboard")

    layers
  end
end

