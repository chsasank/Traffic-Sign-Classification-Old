function EvalTrafficSigns()
% MATLAB Version 7.11.0.584 (R2010b)

% TODO!
% replace this string by the path you saved the benchmark data in
sBasePath = 'X:\TSR-dataset\online_test\'; 

[ImgFiles, Rois] = readSignData([sBasePath, '\GT-online_test.csv']);

ResultFile = [sBasePath, '\classification_results.csv'];
fID = fopen(ResultFile, 'w');

try
    for i = 1:numel(ImgFiles)
        ImgFile = [sBasePath, '\', ImgFiles{i}];
        Img = imread(ImgFile);

        fprintf(1, 'Currently classifying: %s Sample: %d / %d\n', ImgFiles{i}, i, numel(ImgFiles));

        % TODO!
        % if you want to work with a border around the traffic sign
        % comment the following line
        Img = Img(Rois(i, 2) + 1:Rois(i, 4) + 1, Rois(i, 1) + 1:Rois(i, 3) + 1);

        % TODO!
        % replace this line by the function call of your classifier
        Class = MyClassificationFunction(Img);

        fprintf(fID, ['%s %d', char(13), char(10)], ImgFiles{i}, Class);

    end
catch ME
    getReport(ME)
end
fclose(fID);




function [rImgFiles, rRois] = readSignData(aFile)
% Reads the traffic sign data.
%
% aFile         Text file that contains the data for the traffic signs
%
% rImgFiles     Cell-Array (1 x n) of Strings containing the names of the image
%               files to operate on
% rRois         (n x 4)-Array containing upper left column, upper left row,
%               lower left column, lower left row of the region of interest
%               of the traffic sign image. The image itself can have a
%               small border so this data will give you the exact bounding
%               box of the sign in the image

    fID = fopen(aFile, 'r');
    
    fgetl(fID); % discard line with column headers
    
    f = textscan(fID, '%s %*d %*d %d %d %d %d', 'Delimiter', ';');
    
    rImgFiles = f{1}; 
    rRois = [f{2}, f{3}, f{4}, f{5}];
    
    fclose(fID);
    
    
function rClass = MyClassificationFunction(aImg)

fprintf(1, 'You should replace the function MyClassificationFunction() by your own traffic sign classifier.\n');
rClass = -1;
