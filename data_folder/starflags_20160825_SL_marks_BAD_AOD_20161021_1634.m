function marks = starflags_20160825_SL_marks_BAD_AOD_20161021_1634  
 % starflags file for 20160825 created by SL on 20161021_1634 to mark BAD_AOD conditions 
 version_set('20161021_1634'); 
 daystr = '20160825';  
 % tag = 10: unspecified_clouds 
 % tag = 90: cirrus 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:28:42') datenum('10:28:51') 700 
datenum('10:28:58') datenum('10:33:03') 700 
datenum('10:39:31') datenum('10:39:40') 700 
datenum('10:40:16') datenum('10:40:20') 700 
datenum('10:42:19') datenum('10:42:29') 700 
datenum('10:45:12') datenum('10:45:16') 700 
datenum('10:45:24') datenum('10:45:24') 700 
datenum('10:46:13') datenum('10:46:18') 700 
datenum('10:46:40') datenum('10:46:40') 700 
datenum('10:48:42') datenum('10:48:46') 700 
datenum('11:16:08') datenum('11:16:13') 700 
datenum('11:56:04') datenum('11:56:09') 700 
datenum('12:14:24') datenum('12:14:29') 700 
datenum('12:32:44') datenum('12:32:49') 700 
datenum('12:51:04') datenum('12:51:09') 700 
datenum('13:09:24') datenum('13:09:29') 700 
datenum('13:13:15') datenum('13:14:25') 700 
datenum('13:28:15') datenum('13:28:20') 700 
datenum('13:42:13') datenum('13:42:13') 700 
datenum('13:46:25') datenum('13:46:25') 700 
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
datenum('13:13:15') datenum('13:14:23') 10 
datenum('13:42:13') datenum('13:42:13') 10 
datenum('13:46:25') datenum('13:46:25') 10 
datenum('19:21:34') datenum('19:22:09') 10 
datenum('19:22:13') datenum('19:22:15') 10 
datenum('19:22:22') datenum('19:22:22') 10 
datenum('10:39:31') datenum('10:39:40') 90 
datenum('10:40:16') datenum('10:40:20') 90 
datenum('10:42:19') datenum('10:42:29') 90 
datenum('10:45:12') datenum('10:45:16') 90 
datenum('10:45:24') datenum('10:45:24') 90 
datenum('10:46:13') datenum('10:46:18') 90 
datenum('13:14:20') datenum('13:14:25') 90 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return