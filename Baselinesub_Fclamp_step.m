function Baselinesub_Fclamp_step
% Date-26/09/2016   SG
% Run this programm after running the FClamp_Sorting to calculate the
% lifetime
clear 'all';
close 'all';

fclose('all');

folder='C:\Users\Gaurav Kumar Bhati\Desktop\AFM_Folder\P217L experiment\New folder\single';
cd(folder);
mkdir(folder,'noevents');
mkdir(folder,'checked');
mkdir(folder,'modified');
mkdir(folder,'not unbind');
mkdir(folder,'multiplemodified');
mkdir(folder,'multiplechecked');

%mkdir(folder,'multiple');
% fidn=fopen('filenm_Fmean_LT72.txt','w+');
RNumb = rand;
str1 = num2str(RNumb);
nm1 = '_lifetime_force.txt';
nm2 = '_lifetime_force_multiple.txt';
name_create1 = strcat(str1,nm1);
name_create2 = strcat(str1,nm2);
fidn1=fopen(name_create1, 'w+');
fidn2=fopen(name_create2, 'w+');
fprintf(fidn1,'%s, %s, %s\n', 'File_name', 'lifetime', 'Force');
fprintf(fidn2,'%s, %s, %s\n', 'File_name', 'lifetime', 'Force');
di=dir('force-save*.txt');
for i=1:length(di);
    clear s A str n n2 k name k1 l x y x2 y2 xF yF orig findorig findxp;
    name=di(i).name;
    l = load(name);
    x = (l(:,2));
    y = (l(:,3));
    x2 = (l(:,1));
    y2 = (l(:,3));
    xF = x;
    yF = y2;
    H_f=figure;
    zoom on
    set(H_f,'PaperUnits','centimeters')
    xSize = 400;  ySize = 350;
    xLeft = (400-xSize)/3;  yTop = (1000-ySize)/3;
    set(H_f,'position',[xLeft yTop+(ySize/2) xSize ySize])
    plot(x2,y,'.-k')
    title(name)
    xlabel('time')
    ylabel('force (pN)')
    H_l=figure;
    zoom on
    set(H_l,'position',[xLeft+xSize yTop+(ySize/2) xSize ySize])
    plot(xF,yF,'.-k')
    xlabel('height')
    ylabel('force(pN)')
    H_m = figure;
    zoom on
    set(H_m,'position',[xLeft+xSize+xSize yTop+(ySize/2) xSize ySize])
    plot(x2,xF,'.-k')
    xlabel('time')
    ylabel('height')
    pause
    zoom off
    k1=input('enter the operation code(1=copyfile, 2=reject):');
    switch k1;
        case 1;
            disp('accept');
            k2=input('enter the operation code(3=singlestep, 4=multiplestep):');
            switch k2;
                case 3;
                    disp('singlestep');
                    %             findxp = xF<=0;
                    %             findorig = find((yF(findxp)<=0));
                    %             orig = findorig(1);
                    %             hold on
                    %             plot(xF(orig),yF(orig),'.-r')
                    %             hold on
                    %             clear k;
                    %             k= input('enter if origin is correct:');
                    %             if isempty(k)==1
                    %                 x3 = xF-xF(orig);
                    %             else
                    delete (H_f);
                    delete (H_m);
                    zoom on
                    pause
                    zoom off
                    dcm_obj0 = datacursormode(H_l);
                    set(dcm_obj0, 'enable', 'on')
                    pause
                    set(dcm_obj0, 'enable', 'off')
                    c_info0 = getCursorInfo(dcm_obj0);
                    orig =  c_info0.DataIndex;
                    xF = xF-xF(orig);
                    yF = yF - yF(orig);
                    
                    %             end
                    
                    delete(H_l);
                    H_s=figure;
                    plot(x2,y,'.k');
                    zoom on
                    pause
                    zoom off
                    dcm_obj0 = datacursormode(H_s);
                    set(dcm_obj0, 'enable', 'on')
                    pause
                    set(dcm_obj0, 'enable', 'off')
                    c_info0 = getCursorInfo(dcm_obj0);
                    bline =  c_info0.DataIndex;
                    
                    xF = xF(bline)-xF;
                    y3 = y(bline)-y;
                    y8=yF(bline)-yF;
                    x2f = x2-x2(bline);
                    
                    data = nan*ones(length(xF),4);
                    %             data(:,1) = xF;
                    %             data(:,2) = y8;
                    H_n=figure;
                    plot(x2,y3,'.-k')
                    zoom on
                    pause
                    zoom off
                    % enable data cursor mode
                    dcm_obj = datacursormode(H_n);
                    set(dcm_obj, 'enable', 'on')
                    pause
                    % do disable data cursor mode use
                    set(dcm_obj, 'enable', 'off')
                    c_info = getCursorInfo(dcm_obj);
                    zoom on
                    pause
                    zoom off
                    % enable data cursor mode
                    dcm_obj1 = datacursormode(H_n);
                    set(dcm_obj1, 'enable', 'on')
                    pause
                    % do disable data cursor mode use
                    set(dcm_obj1, 'enable', 'off')
                    d_info = getCursorInfo(dcm_obj1);
                    z=(c_info.DataIndex):(d_info.DataIndex);
                    
                    l_time=d_info.Position(:,1)-c_info.Position(:,1);
                    delete(H_n);
                    data = nan*ones(length(xF),4);
                    data(:,1) = x;
                    data(:,2) = xF;
                    data(:,3) = y8;
                    data(:,4) = x2f;
                   
                    %             data(:,4) = y;
                    %             data(:,5) = xF;
                    %             data(:,6) = y8;
                    %             xub=xF((c_info.DataIndex):(d_info.DataIndex));
                    %             fub=y3((c_info.DataIndex):(d_info.DataIndex));commented by
                    %             JPH to get only one force
%                     fub=y3((c_info.DataIndex):(d_info.DataIndex));
%                     force=mean(fub);
                    force=(y3(c_info.DataIndex)+y3(d_info.DataIndex))/2;
                    %             delete(H_k);
                    namen = strcat('mod_single_0.02',name(end-10:end));
                    namel = name(end-10:end);
                    dlmwrite(namen, data,'delimiter','\t');
                    fprintf(fidn1, '%s %f %f\n',namel, l_time,force);
                    movefile(namen,'C:\Users\Gaurav Kumar Bhati\Desktop\AFM_Folder\P217L experiment\New folder\single\modified');
                    movefile(name,'C:\Users\Gaurav Kumar Bhati\Desktop\AFM_Folder\P217L experiment\New folder\single\checked');
                    delete(H_s);
                case 4
                    disp('multiplestep');
                    delete (H_f);
                    delete (H_m);
                    zoom on
                    pause
                    zoom off
                    dcm_obj0 = datacursormode(H_l);
                    set(dcm_obj0, 'enable', 'on')
                    pause
                    set(dcm_obj0, 'enable', 'off')
                    c_info0 = getCursorInfo(dcm_obj0);
                    orig =  c_info0.DataIndex;
                    xF = xF-xF(orig);
                    yF = yF - yF(orig);
                    
                    %             end
                    
                    delete(H_l);
                    H_s=figure;
                    plot(x2,y,'.k');
                    zoom on
                    pause
                    zoom off
                    dcm_obj0 = datacursormode(H_s);
                    set(dcm_obj0, 'enable', 'on')
                    pause
                    set(dcm_obj0, 'enable', 'off')
                    c_info0 = getCursorInfo(dcm_obj0);
                    bline =  c_info0.DataIndex;
                    
                    xF = xF(bline)-xF;
                    y3 = y(bline)-y;
                    y8=yF(bline)-yF;
                    x2f = x2-x2(bline);
                    
                    data = nan*ones(length(xF),4);
                    %             data(:,1) = xF;
                    %             data(:,2) = y8;
                    H_n=figure;
                    plot(x2,y3,'.-k')
                    zoom on
                    pause
                    zoom off
                    % enable data cursor mode
                    dcm_obj = datacursormode(H_n);
                    set(dcm_obj, 'enable', 'on')
                    pause
                    % do disable data cursor mode use
                    set(dcm_obj, 'enable', 'off')
                    c_info = getCursorInfo(dcm_obj);
                    zoom on
                    pause
                    zoom off
                    % enable data cursor mode
                    dcm_obj1 = datacursormode(H_n);
                    set(dcm_obj1, 'enable', 'on')
                    pause
                    % do disable data cursor mode use
                    set(dcm_obj1, 'enable', 'off')
                    d_info = getCursorInfo(dcm_obj1);
                    z=(c_info.DataIndex):(d_info.DataIndex);
                    
                    l_time=d_info.Position(:,1)-c_info.Position(:,1);
                    delete(H_n);
                    data = nan*ones(length(xF),4);
                    data(:,1) = x;
                    data(:,2) = xF;
                    data(:,3) = y8;
                    data(:,4) = x2f;
                    %             data(:,4) = y;
                    %             data(:,5) = xF;
                    %             data(:,6) = y8;
                    %             xub=xF((c_info.DataIndex):(d_info.DataIndex));
                    %             fub=y3((c_info.DataIndex):(d_info.DataIndex));commented by
                    %             JPH to get only one force
%                     fub=y3((c_info.DataIndex):(d_info.DataIndex));
%                     force=mean(fub);
                    force=(y3(c_info.DataIndex)+y3(d_info.DataIndex))/2;
                    %             delete(H_k);
                    namen = strcat('mod_multiple_0.02',name(end-10:end));
                    namel = name(end-10:end);
                    dlmwrite(namen, data,'delimiter','\t');
                    fprintf(fidn2, '%s %f %f\n',namel, l_time,force);
                    movefile(namen,'C:\Users\Gaurav Kumar Bhati\Desktop\AFM_Folder\P217L experiment\New folder\single\multiplemodified');
                    movefile(name,'C:\Users\Gaurav Kumar Bhati\Desktop\AFM_Folder\P217L experiment\New folder\single\multiplechecked');
                    delete(H_s);
            end
        case 2;
            delete (H_m);
            delete(H_f);
            delete (H_l);
            disp('reject');
            movefile(name,'C:\Users\Gaurav Kumar Bhati\Desktop\AFM_Folder\P217L experiment\New folder\single\noevents');
            
    end
    
end
end
