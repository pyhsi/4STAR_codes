function marks = starflags_20160920_O3_MS_marks_CLOUD_EVENTS_20161017_2130  
 % starflags file for 20160920 created by MS on 20161017_2130 to mark CLOUD_EVENTS conditions 
 version_set('20161017_2130'); 
 daystr = '20160920';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('12:14:44') datenum('12:15:45') 03 
datenum('12:15:09') datenum('12:15:09') 700 
datenum('12:15:14') datenum('12:15:17') 700 
datenum('12:14:44') datenum('12:15:45') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return