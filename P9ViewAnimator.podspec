Pod::Spec.new do |s|

  s.name         = "P9ViewAnimator"
  s.version      = "1.0.0"
  s.summary      = "Developers can easily implement animation of views based on key frame with P9ViewAnimator."
  s.homepage     = "https://github.com/P9SOFT/P9ViewAnimator"
  s.license      = { :type => 'MIT' }
  s.author       = { "Tae Hyun Na" => "taehyun.na@gmail.com" }

  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source       = { :git => "https://github.com/P9SOFT/P9ViewAnimator.git", :tag => "1.0.0" }
  s.source_files  = "Sources/*.{h,m}"
  s.public_header_files = "Sources/*.h"

end
