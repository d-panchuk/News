target 'News' do
  use_frameworks!

  pod 'RxCocoa'
  pod 'RxSwift'
  pod 'Kingfisher'

  target 'NewsTests' do
    inherit! :search_paths
    pod 'RxTest'
  end

end

post_install do |installer|
   installer.pods_project.targets.each do |target|
      if target.name == 'RxSwift'
         target.build_configurations.each do |config|
            if config.name == 'Debug'
               config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
            end
         end
      end
   end
end
