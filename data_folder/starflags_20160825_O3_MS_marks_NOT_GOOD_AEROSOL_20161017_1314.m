function marks = starflags_20160825_O3_MS_marks_NOT_GOOD_AEROSOL_20161017_1314  
 % starflags file for 20160825 created by MS on 20161017_1314 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20161017_1314'); 
 daystr = '20160825';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:28:42') datenum('19:26:22') 03 
datenum('10:28:42') datenum('10:46:16') 02 
datenum('10:28:42') datenum('10:28:51') 700 
datenum('10:39:26') datenum('10:39:37') 700 
datenum('10:45:09') datenum('10:45:14') 700 
datenum('10:48:42') datenum('10:48:46') 700 
datenum('11:16:08') datenum('11:16:13') 700 
datenum('11:56:04') datenum('11:56:09') 700 
datenum('12:14:24') datenum('12:14:29') 700 
datenum('12:32:44') datenum('12:32:49') 700 
datenum('12:51:04') datenum('12:51:09') 700 
datenum('13:09:24') datenum('13:09:29') 700 
datenum('13:12:51') datenum('13:14:20') 700 
datenum('13:14:23') datenum('13:14:29') 700 
datenum('13:14:33') datenum('13:14:33') 700 
datenum('13:28:15') datenum('13:28:20') 700 
datenum('13:41:56') datenum('13:41:56') 700 
datenum('13:50:39') datenum('13:50:43') 700 
datenum('14:08:59') datenum('14:09:04') 700 
datenum('14:27:19') datenum('14:27:24') 700 
datenum('14:45:39') datenum('14:45:44') 700 
datenum('15:03:59') datenum('15:04:04') 700 
datenum('15:22:20') datenum('15:22:24') 700 
datenum('15:40:40') datenum('15:40:44') 700 
datenum('16:27:57') datenum('16:28:01') 700 
datenum('16:46:17') datenum('16:46:21') 700 
datenum('17:04:42') datenum('17:04:47') 700 
datenum('17:23:13') datenum('17:23:17') 700 
datenum('17:50:00') datenum('17:50:11') 700 
datenum('18:08:27') datenum('18:08:31') 700 
datenum('18:26:47') datenum('18:26:51') 700 
datenum('18:45:07') datenum('18:45:11') 700 
datenum('19:03:01') datenum('19:26:22') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return