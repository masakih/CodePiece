source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/EZ-NET/PodSpecs.git'

use_frameworks!

def pods

	pod 'ESThread'
	pod 'ESNotification'
	pod 'APIKit'
	pod 'ESGists'
	pod 'p2.OAuth2'
	pod 'ReachabilitySwift'

end

target :CodePiece do

	platform :osx, '10.10'
	use_frameworks!

	pods
	pod 'KeychainAccess', :git => 'https://github.com/kishikawakatsumi/KeychainAccess.git', :branch => 'master'
	pod 'STTwitter'

end

target :ESTwitter do

	platform :osx, '10.10'
	use_frameworks!
	
	pod 'Himotoki'
	pod 'Swim'

end
