

21st Century Free Falling Youtube Masthead Banner

Git Repository:
git@github.com:visualgoodness/T_21stCentury_FreeFall_YoutubeMasthead.git

DoubleClick Login:
http://studio.doubleclick.com/login

Most Recent Preview:
http://studio.doubleclick.com/externalpreview?h=HXDO5bwkfIhz4P4XUfRQpQ%3D%3D%0D%0A

DoubleClick docs:
http://www.google.com/support/richmedia/

Libs: GreenSock: http://www.greensock.com/v11/
      Configured to work with class path "../../supporting_classes"

Assets: /work/DonatWald+Haque/C1614-00001 21st Century WC Banners/Client Supplied
	(same path for work drive and also FTP while moving -- 209.114.44.190 / vgftptemp / L4Py[9.t)

OVERVIEW:
There are three FLA files that create three SWFs that serve as collapsed, expanded and parent components to to the creative.  To expand the banner, a user clicks one of three buttons that correspond to a different video that plays in the expanded panel.  In order to forward the selected ending index from the collapsed banner to the expanded banner, DoubleClick Studio LocalConnection instances are used. 

In the expanded panel, there is a MovieClip instance with name "video_container_mc" which contains three key frames on each of which is a DoubleClick Video instance.  When playing multiple videos, this is the only way it will work properly using DoubleClick's components.  Each video instance in each frame must be configured with the right instance names, identifiers and video URLs.