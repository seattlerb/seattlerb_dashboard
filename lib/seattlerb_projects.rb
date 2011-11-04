
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
    layers = [ # mix of dependencies and priorities

              # most important: the foundation
              %w(hoe hoe-seattlerb),
              %w(ZenTest minitest minitest_tu_shim autotest-rails),

              # base libraries
              %w(RubyInline sexp_processor ssh),
              %w(ParseTree ruby_parser ruby2ruby event_hook rake-remote_task),

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
            # dead, untestable, non-ruby, or otherwise excluded
            Algometer AlgometerX Interpreters newri UNIX Satori
            firebrigade icanhasaudio mogilefs-client rubicon scripts
            stuporslow seattlerb poopcode rubypan rometa ograph
            ZenLibrary yaccpuke zero2rails weight pkg_clean Cocoa
            macports miniunit macports bastard_tetris zombies

            # if you won't write tests others can run, they won't get run.
            gmail_contacts rc-rest UPnP UPnP-ContentDirectory
            memcache-client Sphincter RailsRemoteControl imap_to_rss
            imap_processor

            ".gsub(/\s*\#.*/, '').scan(/\S+/)

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

