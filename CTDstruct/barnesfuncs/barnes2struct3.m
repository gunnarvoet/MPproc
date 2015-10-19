function barnes2struct2%puts the CTD data from the barnes into a ctd structure to be used in%ctdmultiplot.  no inputs needed.  it saves all the output into a workspace%file Barnes_CTD2003.mat.  Puts structure 'barnes' into the base workspace to%be used in graphing.%%Lines 17 and 21 need to be changed for each computer this function is run%on.  Line 21 is the path to the directory containing the data.   Line 17%is the name of the directory which contains the data. %Read in the CTD data from all of the Thompson cruises that Mitsuhiro gave me.%They are in the directory Shortboard:Data:Thompson CTD:.%See the readme file there for details.%This file reads in all profiles and stores them in a large%matrix with accompanying lat, lon, year and yday vectors.%1/29/01%path= 'C:\MatthewHome\';path= '/Users/kim/RESEARCH/CruiseData/2003_11_18/';%path= 'C:\MatthewHome\Data\Thompson CTD\'%cruises=['TN077'; 'TN079'; 'TN087'; 'TN097'; 'TN111'; 'TN119'; 'TN120'];%cruises={'TN143'; 'TN143transect'; 'TN148'};cruises={'2003_11_18CNV'};%fnameout=[path num2str(buoynum) '_' num2str(thisyear) '.mat'];%I'll make a huge array with space for p,t,s for each profilenrecs=20;p=zeros(20000,nrecs)*NaN;th=p;s=p;sgth=p;t=p;dox=p;con=p;trans=p;yday=zeros(1,nrecs)*NaN;year=yday;lat=yday;lon=yday;profilesdone=0;allcounter=[];for c=1:length(cruises)    %DisplayProgress(c,1)    %eval(['cd ''' path cruises(c,:) ''''])    eval(['cd ''' path cruises{c} ''''])    a=dir;    numfiles=length(a);    thisprofile=0;    %They kept the same column order for all three cruises this time 2.28.03	    %switch c    %    case 1, whp=3;wht=1;whs=6;whth=20;whsgth=18;whdox=12;    %     case 2, whp=3;wht=1;whs=6;whth=20;whsgth=18;whdox=12;    %     case 3, whp=3;wht=1;whs=6;whth=21;whsgth=19;whdox=12;    %end    whp=1;wht=2;whth=wht;whs=9;whsgth=21;whdox=20;whcon=3;whtrans=6;                for d=4:numfiles %on windows, skip . and .., in OSX also skip .ds_store        %DisplayProgress(d-2,1)        fname=a(d).name;        fid=fopen(fname);        thisprofile=thisprofile+1;        counter=0;        maxpres=0;        done=0;        %Get header data         for dum=1:9            line=fgetl(fid);        end                %parse the time line        i1=strmatch('=',line');        line2=line(i1:length(line));        i2=strmatch(' ',line2');        mstr=line2(i2(1)+1:i2(2)-1);        if strcmpi(mstr(1:3),'Jan')==1            month=1;        elseif strcmpi(mstr(1:3),'Feb')==1            month=2;        elseif strcmpi(mstr(1:3),'Mar')==1            month=3;        elseif strcmpi(mstr(1:3),'Apr')==1            month=4;        elseif strcmpi(mstr(1:3),'May')==1            month=5;        elseif strcmpi(mstr(1:3),'Jun')==1            month=6;        elseif strcmpi(mstr(1:3),'Jul')==1            month=7;        elseif strcmpi(mstr(1:3),'Aug')==1            month=8;        elseif strcmpi(mstr(1:3),'Sep')==1            month=9;        elseif strcmpi(mstr(1:3),'Oct')==1            month=10;        elseif strcmpi(mstr(1:3),'Nov')==1            month=11;        elseif strcmpi(mstr(1:3),'Dec')==1            month=12;        end        day=str2num(line2(i2(2):i2(3)));        thisyear=str2num(line2(i2(3):i2(4)));        line3=line2(i2(4)+1:length(line2));        line3=line3(2:end);        hour=str2num(line3(1:2));        minute=str2num(line3(4:5));        second=str2num(line3(7:8));                %Now get lat, lon (assumed N,W)        line=fgetl(fid);        i1=strmatch('=',line');        line2=line(i1:length(line));        i2=strmatch(' ',line2');        %Get rid of any two-spaces        i2=i2(find(diffs(i2)~=1));        thislat=str2num(line2(i2(1):i2(2)))+1/60*str2num(line2(i2(2):i2(3)));        line=fgetl(fid);        i1=strmatch('=',line');        line2=line(i1:length(line));        i2=strmatch(' ',line2');        %Get rid of any two-spaces        i2=i2(find(diffs(i2)~=1));        thislon=str2num(line2(i2(1):i2(2)))+1/60*str2num(line2(i2(2):i2(3)));                %Fill in header data        yday(profilesdone+thisprofile)=yearday(day,month,thisyear,hour,minute,second);        year(profilesdone+thisprofile)=thisyear;	        lat(profilesdone+thisprofile)=thislat;	        lon(profilesdone+thisprofile)=thislon;	                %Get past the header        while ~strcmp(line(1:5),'*END*')             line=fgetl(fid);        end        line=fgetl(fid);                %Fill in profile data        while ischar(line)~=done            %DisplayProgress(counter,1000)            counter=counter+1;            %parse the line and stick in the variable            %find all spaces            spaces=strmatch(' ',line');            %we don't want the repeated spaces            ind=find(diffs(spaces) > 1);            %Then the start of each number is             starts=spaces(ind(1:length(ind)-1));            ends=spaces(ind(2:length(ind)));            %wh=3;            thispres=str2num(line(starts(whp):ends(whp)));            p(counter,profilesdone+thisprofile)=thispres;            %wh=12;            %keep a record of the max pressure seen yet in the drop            if thispres > maxpres                maxpres=thispres;            end            %set the done flag if we're on the way up            %if thispres < maxpres - 5            %    done=1;            %end            th(counter,profilesdone+thisprofile)=str2num(line(starts(whth):ends(whth)));            %wh=1;            t(counter,profilesdone+thisprofile)=str2num(line(starts(wht):ends(wht)));            %wh=18;            s(counter,profilesdone+thisprofile)=str2num(line(starts(whs):ends(whs)));            %wh=14;            sgth(counter,profilesdone+thisprofile)=str2num(line(starts(whsgth):ends(whsgth)));            %wh=14;            dox(counter,profilesdone+thisprofile)=str2num(line(starts(whdox):ends(whdox)));            con(counter,profilesdone+thisprofile)=str2num(line(starts(whcon):ends(whcon)));            trans(counter,profilesdone+thisprofile)=str2num(line(starts(whtrans):ends(whtrans)));            line=fgetl(fid);            allcounter=[allcounter,counter];            allcounter=max(allcounter);        end        %Close file        fclose(fid);        disp([num2str(profilesdone+thisprofile) ' profiles completed.'])            end	    profilesdone=profilesdone+thisprofile;end%savestr=['save ''' path cruises '.mat'' yday year p th t s sgth lat lon']savestr=['save ''' path 'barnes_20031118raw.mat'' yday year p th t s sgth dox con trans lat lon'];eval(savestr)% create the structure to be plotted!rows=max(allcounter);col=numfiles-3; % if two files skipped in line 54, col=numfiles-2, if 3 files skipped, col=numfiles-4.%if there is an obscene number of data points, the data will be averaged over a set intervaldz=1;barneyfilt('barnes_20031118raw.mat',dz,rows,col)%put in the base workspacebarnes01=barnes;assignin('base','barnes18',barnes18);savestr=['save ''' path 'barnes20031118.mat'' barnes18'];eval(savestr)