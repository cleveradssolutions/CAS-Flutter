#!/usr/bin/env ruby

# Adds CAS.AI mediation adapters to an Xcode project as Swift Package products.
#
# Swift Package Manager has no equivalent of the CocoaPods subspec, so adapters
# cannot be listed in a Podfile any more: they are package products attached to
# the application target. Xcode only offers to attach them by hand, which leaves
# the choice of adapters outside the repository. This script puts that choice
# back into a file you can review and run in CI.
#
# Run it from the directory that holds the .xcodeproj, after `flutter build ios`
# has created the project's Swift Package Manager integration.

require 'set'
require 'xcodeproj'

module CASAdapters
    PACKAGE_URL = 'https://github.com/cleveradssolutions/CAS-iOS.git'
    PACKAGE_NAME = 'CAS-iOS'
    PRODUCT_PREFIX = 'CASMediation'
    DEFAULT_VERSION = '4.8.3-beta1'

    XC_PROJECT_FILE = '.xcodeproj'
    SCRIPT_VERSION = '1.0'

    ARG_PROJECT = '--project='
    ARG_VERSION = '--version='
    ARG_SOLUTION = '--solution='
    ARG_PRUNE = '--prune'
    ARG_LIST = '--list'
    ARG_HELP = '--help'

    # Adapters that CAS-iOS publishes as Swift Package products.
    # Keep in sync with Adapters/README.md, the SPM column.
    SPM_ADAPTERS = %w[
        AppLovin AudienceNetwork Bidease Bigo BlueSea CASExchange Chartboost
        CrossPromo DisplayIO DTExchange GoogleAds HyprMX InMobi IronSource
        Kidoz LiftoffMonetize Mintegral Moloco Ogury Pangle Prado PubMatic
        Smaato StartIO UnityAds Verve YangoAds YsoNetwork
    ].freeze

    # Adapters that exist for CocoaPods only. Requesting one is not an error:
    # the script reports it and configures the rest.
    NO_SPM_ADAPTERS = %w[Maticoo Monetrix SuperAwesome].freeze

    # The ready-made sets, mirroring the CleverAdsSolutions-SDK subspecs.
    SOLUTIONS = {
        'optimal' => %w[
            IronSource UnityAds GoogleAds LiftoffMonetize InMobi Mintegral
            AppLovin Pangle Bigo YangoAds AudienceNetwork YsoNetwork
            CASExchange Maticoo
        ],
        'families' => %w[
            IronSource UnityAds GoogleAds LiftoffMonetize InMobi Chartboost
            Kidoz Mintegral YangoAds
        ],
        'vpn' => %w[
            IronSource UnityAds GoogleAds LiftoffMonetize InMobi Mintegral
            Bigo YangoAds YsoNetwork Monetrix
        ]
    }.freeze

    class << self
        attr_accessor :project_path, :version, :adapters, :prune

        def configure
            Dir.chdir __dir__
            yield self if block_given?

            project = Project.new(@project_path)
            package = project.ensure_package(@version)
            project.apply_adapters(package, @adapters, @prune)
            project.save

            print_footer
        end

        def read_from_args
            @project_path = ''
            @version = DEFAULT_VERSION
            @prune = false
            requested = []

            ARGV.each do |arg|
                if arg == ARG_HELP
                    print_help
                elsif arg == ARG_LIST
                    print_adapters
                elsif arg == ARG_PRUNE
                    @prune = true
                elsif arg.start_with?(ARG_PROJECT)
                    @project_path = read_project_path(arg.sub(ARG_PROJECT, ''))
                elsif arg.start_with?(ARG_VERSION)
                    @version = arg.sub(ARG_VERSION, '')
                elsif arg.start_with?(ARG_SOLUTION)
                    requested += read_solution(arg.sub(ARG_SOLUTION, ''))
                elsif arg.start_with?('--')
                    error('[!] Unknown option: ' + arg)
                    print_help
                else
                    requested << read_adapter(arg)
                end
            end

            if requested.empty?
                error('[!] No adapters requested.')
                print_help
            end

            @adapters = resolve(requested)
        end

        # Matches the requested names against the known ones, case insensitively,
        # and reports the ones that have no Swift Package product.
        def resolve(requested)
            known = (SPM_ADAPTERS + NO_SPM_ADAPTERS)
                    .each_with_object({}) { |name, acc| acc[name.downcase] = name }

            resolved = Set.new
            unknown = []
            requested.uniq.each do |name|
                match = known[name.downcase]
                if match.nil?
                    unknown << name
                else
                    resolved << match
                end
            end

            unless unknown.empty?
                error('[!] Unknown adapters: ' + unknown.join(', '))
                puts '    Run with ' + ARG_LIST + ' to see every supported name.'
                exit!
            end

            skipped = resolved.select { |name| NO_SPM_ADAPTERS.include?(name) }
            unless skipped.empty?
                warning('- No Swift Package product yet: ' + skipped.sort.join(', '))
                puts '   These adapters are available through CocoaPods only.'
                puts '   The app is configured without them.'
            end

            resolved.reject { |name| NO_SPM_ADAPTERS.include?(name) }.sort
        end

        def read_solution(name)
            set = SOLUTIONS[name.downcase]
            if set.nil?
                error('[!] Unknown solution: ' + name)
                puts '    Supported: ' + SOLUTIONS.keys.join(', ')
                exit!
            end
            set
        end

        def read_adapter(name)
            # Both 'GoogleAds' and the full product name are accepted.
            name.start_with?(PRODUCT_PREFIX) ? name.sub(PRODUCT_PREFIX, '') : name
        end

        def read_project_path(path)
            path += XC_PROJECT_FILE unless path.end_with?(XC_PROJECT_FILE)
            unless File.exist?(path)
                error('[!] Not found project: ' + path)
                print_help
            end
            path
        end

        def print_adapters
            puts ''
            success 'Swift Package adapters:'
            SPM_ADAPTERS.each_slice(4) { |row| puts '   ' + row.join(', ') }
            puts ''
            warning 'CocoaPods only, no Swift Package product:'
            puts '   ' + NO_SPM_ADAPTERS.join(', ')
            puts ''
            success 'Ready-made solutions:'
            SOLUTIONS.each do |name, set|
                missing = set & NO_SPM_ADAPTERS
                note = missing.empty? ? '' : thin_text('  (without ' + missing.join(', ') + ')')
                puts '   ' + ARG_SOLUTION + name + note
            end
            print_footer
            exit!
        end

        def print_help
            puts ''
            warning 'Usage:'
            puts '   Place the script next to the ' + XC_PROJECT_FILE + ' file'
            puts '   and name the adapters your app needs:'
            puts ''
            print '    $ '
            success 'ruby casadapters.rb GoogleAds UnityAds LiftoffMonetize'
            puts ''
            print '    $ '
            success 'ruby casadapters.rb ' + ARG_SOLUTION + 'optimal'
            puts ''
            warning 'Options:'
            success '    ' + ARG_SOLUTION + 'optimal|families|vpn'
            puts '        Add a ready-made set instead of naming adapters one by one'
            success '    ' + ARG_VERSION + 'X.Y.Z'
            puts '        CAS iOS version to resolve, up to the next minor.'
            puts '        Default: ' + DEFAULT_VERSION
            success '    ' + ARG_PROJECT + 'XCodeProjectName'
            puts '        Specify the app project when several sit in one folder'
            success '    ' + ARG_PRUNE
            puts '        Also detach adapters that this run did not ask for'
            success '    ' + ARG_LIST
            puts '        Print every supported adapter and solution'
            success '    ' + ARG_HELP
            puts '        Show help banner of specified command'
            print_footer
            exit!
        end

        def print_footer
            puts ''
            puts thin_text('CAS adapters script version ' + SCRIPT_VERSION)
            puts thin_text('   Powered by ') + colortxt('CAS.ai', 36)
        end

        def error(message)
            puts colortxt(message, 31)
        end

        def success(message)
            puts colortxt(message, 32)
        end

        def warning(message)
            puts colortxt(message, 33)
        end

        def thin_text(message)
            colortxt(message, 2)
        end

        def colortxt(txt, term_color_code)
            "\e[#{term_color_code}m#{txt}\e[0m"
        end
    end

    class Project
        def initialize(project_name)
            path = project_name.empty? ? find_project : project_name
            puts 'Target: ' + path
            @project = Xcodeproj::Project.open(path)

            main_target_name = File.basename(path, XC_PROJECT_FILE)
            @target = @project.targets.find { |t| t.name == main_target_name }
            @target ||= @project.native_targets.first
            if @target.nil?
                CASAdapters.error('[!] No application target in ' + path)
                exit!
            end
            @is_dirt = false
        end

        def find_project
            found = Dir.glob('*' + XC_PROJECT_FILE)
            if found.empty?
                Dir.chdir File.expand_path('../')
                found = Dir.glob('*' + XC_PROJECT_FILE)
            end
            if found.empty?
                CASAdapters.error('[!] XCode project not found')
                CASAdapters.print_help
            end
            return found.first if found.count == 1

            CASAdapters.warning('Found several XC Projects near the script.')
            CASAdapters.warning('Add the --project option with target application project:')
            found.each { |file| CASAdapters.success('   ' + ARG_PROJECT + file) }
            exit!
        end

        # Returns the CAS-iOS package reference of the project, creating it when
        # the project has none and updating its version when it differs.
        def ensure_package(version)
            requirement = { 'kind' => 'upToNextMinorVersion', 'minimumVersion' => version }
            package = @project.root_object.package_references.find do |ref|
                ref.isa == 'XCRemoteSwiftPackageReference' &&
                    ref.repositoryURL.to_s.include?(PACKAGE_NAME)
            end

            if package.nil?
                package = @project.new(Xcodeproj::Project::Object::XCRemoteSwiftPackageReference)
                package.repositoryURL = PACKAGE_URL
                package.requirement = requirement
                @project.root_object.package_references << package
                CASAdapters.success('- Package ' + PACKAGE_NAME + ' ' + version + ' has been added')
                @is_dirt = true
            elsif package.requirement != requirement
                was = package.requirement['minimumVersion']
                package.requirement = requirement
                CASAdapters.success('- Package ' + PACKAGE_NAME + ' moved from ' + was.to_s + ' to ' + version)
                @is_dirt = true
            else
                puts '- Package ' + PACKAGE_NAME + ' ' + version + ' is up-to-date'
            end
            package
        end

        def apply_adapters(package, adapters, prune)
            wanted = adapters.map { |name| PRODUCT_PREFIX + name }
            attached = @target.package_product_dependencies.select { |dep| dep.package == package }
            attached_names = attached.map(&:product_name)

            added = wanted - attached_names
            added.each { |product| attach(package, product) }

            removed = prune ? attached_names - wanted : []
            removed.each { |product| detach(product) }

            if added.empty? && removed.empty?
                puts '- Adapters are up-to-date: ' + (attached_names.empty? ? 'none' : attached_names.sort.join(', '))
            else
                CASAdapters.success('- Adapters attached: ' + added.sort.join(', ')) unless added.empty?
                CASAdapters.success('- Adapters detached: ' + removed.sort.join(', ')) unless removed.empty?
            end

            # Adapters ship Objective-C categories that the linker drops without it.
            ensure_objc_flag
        end

        def attach(package, product_name)
            dependency = @project.new(Xcodeproj::Project::Object::XCSwiftPackageProductDependency)
            dependency.package = package
            dependency.product_name = product_name
            @target.package_product_dependencies << dependency

            build_file = @project.new(Xcodeproj::Project::Object::PBXBuildFile)
            build_file.product_ref = dependency
            @target.frameworks_build_phase.files << build_file
            @is_dirt = true
        end

        def detach(product_name)
            @target.frameworks_build_phase.files.dup.each do |file|
                next unless file.product_ref && file.product_ref.product_name == product_name

                file.remove_from_project
            end
            @target.package_product_dependencies.dup.each do |dependency|
                next unless dependency.product_name == product_name

                @target.package_product_dependencies.delete(dependency)
                dependency.remove_from_project
            end
            @is_dirt = true
        end

        def ensure_objc_flag
            updated = false
            @target.build_configurations.each do |config|
                flags = config.build_settings['OTHER_LDFLAGS'] || ['$(inherited)']
                flags = [flags] if flags.is_a?(String)
                next if flags.include?('-ObjC')

                flags.unshift('-ObjC')
                config.build_settings['OTHER_LDFLAGS'] = flags
                updated = true
            end
            if updated
                CASAdapters.success('- OTHER_LDFLAGS updated with -ObjC')
                @is_dirt = true
            else
                puts '- -ObjC is defined'
            end
        end

        def save
            unless @is_dirt
                puts 'Nothing to change'
                return
            end
            @project.save
            puts 'Updated: ' + @project.path.to_s
            puts ''
            puts 'Open the project in Xcode, or run the build, to resolve the packages.'
        end
    end
end

if __FILE__ == $PROGRAM_NAME
    CASAdapters.configure(&:read_from_args)
end
