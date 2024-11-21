platform :ios, '12.0'
use_frameworks!

workspace 'ios-admob-mediation-sample'

def ios_admob_mediation_pods
  podspec :path => '../ios-admob-mediation/startio-admob-mediation.podspec'
end

target 'ios-admob-mediation-sample' do
  ios_admob_mediation_pods
end

target 'StartioAdmobMediation' do
  project '../ios-admob-mediation/StartioAdmobMediation.xcodeproj'
  ios_admob_mediation_pods
end
