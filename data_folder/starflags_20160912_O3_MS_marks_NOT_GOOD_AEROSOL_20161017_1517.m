function marks = starflags_20160912_O3_MS_marks_NOT_GOOD_AEROSOL_20161017_1517  
 % starflags file for 20160912 created by MS on 20161017_1517 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20161017_1517'); 
 daystr = '20160912';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:32:49') datenum('15:59:26') 03 
datenum('15:58:09') datenum('15:59:26') 02 
datenum('07:32:49') datenum('07:32:59') 700 
datenum('07:51:14') datenum('07:51:19') 700 
datenum('08:09:34') datenum('08:09:39') 700 
datenum('08:27:54') datenum('08:27:59') 700 
datenum('08:46:14') datenum('08:46:19') 700 
datenum('09:04:34') datenum('09:04:39') 700 
datenum('09:22:55') datenum('09:22:59') 700 
datenum('09:41:15') datenum('09:41:19') 700 
datenum('09:59:35') datenum('09:59:40') 700 
datenum('10:00:38') datenum('10:00:38') 700 
datenum('10:17:55') datenum('10:18:00') 700 
datenum('10:36:15') datenum('10:36:20') 700 
datenum('10:54:35') datenum('10:54:40') 700 
datenum('11:12:56') datenum('11:13:00') 700 
datenum('11:30:15') datenum('11:30:15') 700 
datenum('12:01:48') datenum('12:05:28') 700 
datenum('12:07:27') datenum('12:07:31') 700 
datenum('12:39:39') datenum('12:39:44') 700 
datenum('13:00:55') datenum('13:01:00') 700 
datenum('13:22:35') datenum('13:22:40') 700 
datenum('13:23:03') datenum('13:23:03') 700 
datenum('13:28:15') datenum('13:28:16') 700 
datenum('13:28:24') datenum('13:28:24') 700 
datenum('13:28:46') datenum('13:28:46') 700 
datenum('13:28:48') datenum('13:28:48') 700 
datenum('13:28:56') datenum('13:28:57') 700 
datenum('13:30:38') datenum('13:30:38') 700 
datenum('13:30:48') datenum('13:30:49') 700 
datenum('13:33:22') datenum('13:33:22') 700 
datenum('13:33:27') datenum('13:33:29') 700 
datenum('13:35:24') datenum('13:35:24') 700 
datenum('13:36:05') datenum('13:36:06') 700 
datenum('13:36:24') datenum('13:36:26') 700 
datenum('13:39:12') datenum('13:39:12') 700 
datenum('13:39:23') datenum('13:39:24') 700 
datenum('13:48:08') datenum('13:48:13') 700 
datenum('14:08:51') datenum('14:08:56') 700 
datenum('14:27:11') datenum('14:27:16') 700 
datenum('14:45:31') datenum('14:45:36') 700 
datenum('15:03:52') datenum('15:03:56') 700 
datenum('15:22:12') datenum('15:22:16') 700 
datenum('15:25:03') datenum('15:25:03') 700 
datenum('15:40:32') datenum('15:40:36') 700 
datenum('15:41:14') datenum('15:59:26') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return