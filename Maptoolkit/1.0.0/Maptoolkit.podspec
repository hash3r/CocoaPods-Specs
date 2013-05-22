Pod::Spec.new do |s|
  s.name         = "Maptoolkit"
  s.version      = "1.0.0"
  s.summary      = "The map and geolocation framework used in all Toursprung apps."
  s.homepage     = "http://www.toursprung.com/products/maptoolkit/"

  s.license      = 'MIT (example)'
  s.author       = { "Toursprung" => "buro@toursprung.com" }
  s.source       = { :git => "git@github.com:toursprung/Maptoolkit-iOS-SDK.git", :tag => "1.0.0" }

  s.source_files = 'Maptoolkit/Classes/**/*.{h,m}', 'Maptoolkit/Views/**/*.{h,m}'
  s.public_header_files = 'Maptoolkit/Classes/**/*.h', 'Maptoolkit/Views/**/*.{h}'
  
  s.resources = ["Maptoolkit/Resources/**/*.*", "Maptoolkit/i18n/*.lproj"]
  s.preserve_paths = "Maptoolkit/frameworks/**/*.*"

  s.frameworks = 'Maptoolkit', 'CoreTelephony', 'OpenGLES', 'QuartzCore', 'Accounts', 'CoreText', 'MessageUI', 'CoreImage', 'CoreLocation', 'CoreGraphics', 'MobileCoreServices', 'SystemConfiguration'

  s.ios.xcconfig       =  { 'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/Maptoolkit/Maptoolkit/frameworks"' }

  s.libraries = 'z', 'sqlite3', 'icucore'
  s.library = 'Proj4' # hack to make the MapBox pod work. Try to remove this later and see if they have fixed it.

  s.requires_arc = true

  def s.post_install(target_installer)
    # copy the resources but make sure they are copied last.
    # this enables us to override resources from any pod with the apps resources.
    require 'fileutils'
    File.open(target_installer.copy_resources_script_path, 'a') do |file|
      files = FileList.new()
      files.include('Resources/**/*.*')
      files.exclude('Resources/**/*.bundle/**/*')
      files.each do |resource|
        file.puts "install_resource '../" + resource + "'"
      end
      file.puts "rsync -avr --no-relative --exclude '*/.svn/*' --files-from=\"$RESOURCES_TO_COPY\" / \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}\""
      file.puts "rm \"$RESOURCES_TO_COPY\""
    end
  end

  def s.post_install(target_installer)
    # Remove comments from the ConfigGeneral.json file
    require 'fileutils'
    File.open(target_installer.copy_resources_script_path, 'a') do |file|
      file.puts "perl -i -p0e 's!\/\\*.*?\\*\/!!sg' ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/ConfigGeneral.json"
    end
  end

  def s.post_install(target_installer)
    puts "Downloading Documentation"
    `curl -O http://configserver.no-ip.org:12345/~toursprung/docs/com.toursprung.maptoolkit.docset.zip`
    puts "Installing Documentation"
    `rm -fR ~/Library/Developer/Shared/Documentation/DocSets/com.toursprung.maptoolkit.docset`
    `unzip com.toursprung.maptoolkit.docset.zip -d ~/Library/Developer/Shared/Documentation/DocSets/com.toursprung.Maptoolkit.docset`
    `rm com.toursprung.maptoolkit.docset.zip`
  end
  
 


end
