function MSD_of_clamp_experiment
%This program will calculate the MSD during the force clamp period after
%selecting the ROI
%Program written by Gaurav Kumar Bhati
clear 'all';
close 'all';
global out;
fclose('all');
folder = ('C:\Users\Gaurav Kumar Bhati\Desktop\AFM_Folder\AFM_Monomer\R278Q\processed_files\filtered_files\single');
cd(folder);
mkdir(folder,'sorted');
mkdir(folder,'reject');
RNumb = rand;
str1 = num2str(RNumb);
nm1 = '_kmol.txt';
name_create = strcat(str1, nm1);
fidn = fopen(name_create, 'a+');
fprintf(fidn, '%s, %s, %s, %s, %s, %s\n', 'name', 'ks', 'force', 'zm', 'zm2', 'kmol');
di = dir('force-save*.txt');

ks = 30; % Spring constant of the cantilever
for i = 1:length(di)
    clear s A str n n2 k name S1 x y kmol b1 b2 y2 zm;
    name = di(i).name;
    l = load(name);
    fprintf(1, '%s %s\n', 'Analyzing file:', name);
    
    x = l(:,1); % Convert to nm
    y = l(:,3); % Convert to pN
    z = l(:,2); % Tip-surface distance in nm
    
    b = 4/3;
    a = b/4;
    
    H_i = figure;
    plot(x, y, '.-k');
    zoom on;
    pause;
    zoom off;
    
    k1 = input('Enter the operation code (1=copyfile, 2=reject):');
    delete(H_i);
    
    switch k1
        case 1
            disp('Accept');
            N = input('How many unfoldings do you observe? :');
            
            for i1 = 1:N
                H_f = figure;
                plot(x, y, '.-k');
                zoom on;
                pause;
                zoom off;
                
                select_rect('on');
                pause;
                b2 = find(x >= out(1) & x <= out(3));
                y2 = y(b2);
                %y2 = y2* 41; Scaling factor
                F = mean(y2); % Mean force (in nm)
                zm = std(y2); % Standard deviation (fluctuation)
                zm2 = mean((y2 - F).^2); % Proper MSD formula % Corrected MSD calculation        
                select_rect('clean');
                kmol = ks * ((b * 4.1 - ks * zm2) / (ks * zm2 - a * 4.1));
                zoom off;
                
                fprintf(fidn, '%s %f %f %f %f %f \n', name, ks, F, zm, zm2, kmol);
                delete(H_f);
            end
    end
    
    disp('Reject');
    movefile(name, 'C:\Users\Gaurav Kumar Bhati\Desktop\AFM_Folder\AFM_Monomer\R278Q\processed_files\filtered_files\single\sorted');
    delete(H_i);
end

fclose(fidn);
end
