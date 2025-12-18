% Define the folder containing the processed data files
processed_folder = 'C:\Users\Gaurav Kumar Bhati\Desktop\AFM_Folder\P217L experiment\processed_files';

% Define the folder to save filtered files
filtered_folder = fullfile(processed_folder, 'filtered_files');
if ~exist(filtered_folder, 'dir')
    mkdir(filtered_folder);
end

% Get all files matching the pattern "force-save*.txt"
files = dir(fullfile(processed_folder, 'force-save*.txt'));

% Loop through each file
for i = 1:length(files)
    filename = fullfile(processed_folder, files(i).name); % Get full path
    fprintf('Processing file: %s\n', files(i).name);
    
    % Read the file
    data = readmatrix(filename);
    
    % Check if the file has at least 5 columns
    if size(data, 2) >= 5
        % Extract Time (4th column), Distance (1st column), and Force (2nd column)
        time = data(:, 4);
        distance_nm = data(:, 1) * 1e9;  % Convert meters to nanometers
        force_pN = data(:, 2) * 1e12;    % Convert Newtons to picoNewtons
        
        % Combine the modified columns
        data_filtered = [time, distance_nm, force_pN];
        
        % Define new file path
        new_filename = fullfile(filtered_folder, files(i).name);
        
        % Save the filtered data
        writematrix(data_filtered, new_filename, 'Delimiter', ' ');
        
        fprintf('Filtered file saved: %s\n', files(i).name);
    else
        fprintf('Skipping file (not enough columns): %s\n', files(i).name);
    end
end

fprintf('Processing complete. Filtered files are saved in: %s\n', filtered_folder);