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
        ! system "p4 diff2 -u #{ver.last}/... dev/... | grep -q ."
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
          version = File.read(file)[/VERSION = ([\"\'])([\d][\da-z\.]+)\1/, 2]
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
    layers = [ # mix of dependencies and priorities

              # most important: the foundation
              %w(hoe hoe-seattlerb),
              %w(ZenTest minitest autotest-rails),

              # base libraries
              %w(RubyInline sexp_processor),
              %w(ruby_parser oedipus_lex ruby2ruby),

              # medium level - grouped by rough category
              %w(flog flay debride),

              # medium level - minitest plugins
              %w(minitest-autotest minitest-bisect minitest-gcstats
                 minitest-server minitest-unordered minitest-bacon
                 minitest-focus minitest-debugger minitest-happy
                 minitest-macruby minitest-excludes minitest-sprint),

              # medium level - flog/flay/other plugins
              %w(flay-persistence debride-erb),

              %w(image_science png graph),
              %w(vlad vlad-perforce rake-remote_task),
              %w(ZenWeb zenweb-template ohmygems makerakeworkwell),

              %w(omnifocus omnifocus-bugzilla omnifocus-github
                 omnifocus-redmine omnifocus-rt omnifocus-rubyforge),

              %w(gauntlet ssh ruby_to_c wilson),

              # toys and soon to be more "serious"

              %w(osx_keychain rubygems-cleanroom rubygems-sandbox
                 rubygems-checkcert rubygems-sing rdoc_osx_dictionary),

              # things I'm phasing out
              %w(event_hook zenprofile),
             ]

    hold = "
            # dead, untestable, non-ruby, or otherwise excluded
            Algometer AlgometerX Interpreters newri UNIX Satori
            firebrigade icanhasaudio mogilefs-client rubicon scripts
            stuporslow seattlerb poopcode rubypan rometa ograph
            ZenLibrary yaccpuke zero2rails weight pkg_clean Cocoa
            macports miniunit macports bastard_tetris zombies
            minitest_bench

            # if pete and I ever get off our butts
            heckle

            # EOL'd
            minitest_tu_shim ParseTree

            noms

            # my oooold crap
            ZenGraph RubyAudit cocor

            # if you won't write tests others can run, they won't get run.
            gmail_contacts rc-rest UPnP UPnP-ContentDirectory
            memcache-client Sphincter RailsRemoteControl imap_to_rss
            imap_processor
            UPnP-ConnectionManager UPnP-MediaServer
            rails_analyzer_tools production_log_analyzer

            ZenHacks autotest-screen change_class un yoda drawr
            box_layout RubyInlineFortran

            # non-traditional project structures
            fitbit autotest bfts metaruby seattlerb_dashboard

            # eric's abandonware
            IMAPCleanse Inliner RailsRemoteControl RingyDingy
            Sphincter SuperCaller SyslogLogger UPnP-ConnectionManager
            UPnP-ContentDirectory UPnP-IGD UPnP-MediaServer UPnP
            ZenCallGraph action_profiler ar_mailer cached_model
            firebrigade_api gmail_contacts imap_to_rss mem_inspect
            memcache-client mogilefs-client orca_card
            production_log_analyzer rails_analyzer_tools rbayes
            rc-rest rubygems-isit19 rubypan smtp_tls tinderbox

            ".gsub(/\s*\#.*/, '').scan(/\S+/)

    overlap = hold & layers.flatten

    p :overlap => overlap unless overlap.empty?

    hold += layers.flatten

    # grab everything else we've missed and add them
    src_dir = File.expand_path("~/Work/p4/zss/src")
    Dir.chdir src_dir do
      layers << Dir["*"].find_all { |d|
        d !~ /^\./ and File.directory?(d) and not hold.include? d
      }.sort_by { |d| -File.mtime(d).to_i }
    end

    layers
  end
end
