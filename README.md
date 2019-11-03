<h2> Geofencing iOS App using Swift 5 and MVC Architecture </h2>
<h6> This app designed to detect circle or polygon regions based on updating location. Below dropbox video shows the flow of using this app. </h6>
</br>

<a href="https://www.dropbox.com/s/yr8rzzr801qy649/record.mov?dl=0">
  <img src="https://github.com/JSHAMMR/Geofencing/blob/master/Docs/Screenshot%202019-11-04%20at%201.13.04%20AM.png" 
alt="IMAGE ALT TEXT HERE" width="651" height="400" border="10" /></a>

</br>
</br>


<h5> Geofencing monitoring in iOS has limitation as it supports circle region only  (CLCircularRegion). So We have to think in different way to implement polygon regions because the majority of regions are in polygon shape.</h5>

<h6> Because of that I used third party library which is Google map to check if the point lies of path coordinates and it worked successfully.</h6>

</br>

<h5> Background mode</h5>

<h6> This type of application required to work while the device in sleep mode, so the feature has been added to this app. </h6>



<h2>Software required</h2>

<ul>
  <li>cocoa pods 1.6.0 or later</li>
  <li>pod 'GoogleMaps'</li>
</ul>

<h2>Setup</h2>

<ul>
 <li> For Wifi setting please change "YOUR SSID" and  "YOUR BSSID"  </li>
 <li> For app flow please follow the above dropbox video  </li>
  
 <li style="color:red;">To get Wifi info you have to use app id which configured to allow this feature on developer account  </li>


</ul>

<h2>Creat fake routing </h2>
<ul>
 <li>Using google map to get direction of any route then use this website https://mapstogpx.com/ to convert to GPX </li>
</ul>
<h2>See</h2>
<ul>
 <li> iOS Monitoring <a href="https://developer.apple.com/documentation/corelocation/monitoring_the_user_s_proximity_to_geographic_regions">link</a></li>
  <li> GMS Geometry <a href="https://developers.google.com/maps/documentation/ios-sdk/reference/group___geometry_utils.html#gaba958d3776d49213404af249419d0ffd">link</a></li>
</ul>




