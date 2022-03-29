% Student Name : Marnim Galib
% Student ID   : 1001427030

function [ ] = dtw_classify( varargin )
% READING AND CREATING DATA
% READING TRAINING DATA
a = varargin{1};
b = string(a);
c = varargin{2};
d = string(c);
filename = b;%'asl_training.txt';
delimiter = '\t';
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);

raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2]
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            invalidThousandsSeparator = false;
            if any(numbers==',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            
            if ~invalidThousandsSeparator
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end

R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw);
raw(R) = {NaN};

asltraining = cell2mat(raw);
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;

% CREATING TRAINING SAMPLES

[j, k] = size(asltraining);

countA = 0;
sidx = 0;
var1 = 0;
var2 = 0;
sample = 1;
cumA = 0;

for  i = 1 : j
    
    if (isnan(asltraining(i,1)) | isnan(asltraining(i,2))) == 0 && i<j
        sidx = sidx + 1;
        var2 = 1;
    elseif (isnan(asltraining(i,1)) | isnan(asltraining(i,2))) == 1 && var2 == 0
        countA = countA + 1;
        var1 = 1;
    elseif (isnan(asltraining(i,1)) | isnan(asltraining(i,2))) == 1 && var2 == 1
        countB = countA + sidx;
        temp = asltraining((cumA+countA+1:cumA+countB),:);
        temp_val = asltraining(cumA +(countB - sidx -2),1);
        handface_normalized_training{sample,1} = temp;
        handface_normalized_training{sample,2} = temp_val;
        
        countA = 1;
        sidx = 0;
        var1 = 0;
        var2 = 0;
        sample = sample + 1;
        cumA = cumA + countB;
    elseif i == j
        temp = asltraining((cumA+countA+1:j),:);
        temp_val = asltraining(cumA + 3,1);
        handface_normalized_training{sample,1} = temp;
        handface_normalized_training{sample,2} = temp_val;
    end
    
end

% READING TEST DATA
filename = d;%'asl_test1.txt';
delimiter = '\t';
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);

raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2]
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            invalidThousandsSeparator = false;
            if any(numbers==',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            if ~invalidThousandsSeparator
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end

R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

asltest = cell2mat(raw);
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;

[j, k] = size(asltest);

countA = 0;
sidx = 0;
var1 = 0;
var2 = 0;
sample = 1;
cumA = 0;

for  i = 1 : j
    
    if (isnan(asltest(i,1)) | isnan(asltest(i,2))) == 0 && i<j
        sidx = sidx + 1;
        var2 = 1;
    elseif (isnan(asltest(i,1)) | isnan(asltest(i,2))) == 1 && var2 == 0
        countA = countA + 1;
        var1 = 1;
    elseif (isnan(asltest(i,1)) | isnan(asltest(i,2))) == 1 && var2 == 1
        countB = countA + sidx;
        temp = asltest((cumA+countA+1:cumA+countB),:);
        temp_val = asltest(cumA +(countB - sidx -2),1);
        handface_normalized_testing{sample,1} = temp;
        handface_normalized_testing{sample,2} = temp_val;
        
        countA = 1;
        sidx = 0;
        var1 = 0;
        var2 = 0;
        sample = sample + 1;
        cumA = cumA + countB;
    elseif i == j
        temp = asltest((cumA+countA+1:j),:);
        temp_val = asltest(cumA + 3,1);
        handface_normalized_testing{sample,1} = temp;
        handface_normalized_testing{sample,2} = temp_val;
    end
    
end

% DTW
test_samples = size(handface_normalized_testing,1);
training_samples = size(handface_normalized_training,1);
k = 1;
D = zeros(test_samples, training_samples);
sorteddistance = zeros(test_samples, k);
sortingneighbours = zeros(test_samples, k);

for test = 1 : test_samples
    fprintf('Processing Test Sample %d \n',test);
    y = handface_normalized_testing{test,1};
    
    for training = 1 : training_samples
        x = handface_normalized_training{training,1};
        D(test, training) = my_dtw(x,y);
    end
    new_D = D(test,:);
    [sortedX,sortingIndices] = sort(new_D,'ascend');
    sorteddistance(test,:) = sortedX(1:k);
    sortingneighbours(test,:) = sortingIndices(1:k);
end

count = 0;
for test =  1 : test_samples
    true_class = handface_normalized_testing{test,2};
    nneighbour = sortingneighbours(test,1);
    predicted_class = handface_normalized_training{nneighbour,2};
    distance = sorteddistance(test,1);
    if true_class == predicted_class
        count = count + 1;
        sample_accuracy = 1;
    else
        sample_accuracy = 0;
    end
    fprintf('ID=%5d, predicted=%3d, true=%3d, accuracy=%4.2f, distance = %.2f\n', test, predicted_class, true_class, sample_accuracy, distance);
end

accuracy = count/test_samples;
fprintf('classification accuracy=%6.4f\n',accuracy);


function [final_cost] = my_dtw(xx, yy)

cost_grid = zeros(size(yy,1), size(xx,1));

cost_grid(1,1) = norm(yy(1,:)-xx(1,:));
for jj = 2 : size(xx,1)
    cost_grid(1,jj) =  cost_grid(1,jj-1)+ norm(yy(1,:)-xx(jj,:));
end

for ii = 2 : size(yy,1)
    cost_grid(ii,1) =  cost_grid(ii-1,1)+ norm(yy(ii,:)-xx(1,:));
end

for ii = 2 : size(yy,1)
    for jj = 2 : size(xx,1)
        local_dis = norm(yy(ii,:)-xx(jj,:));
        global_minimum = min([cost_grid(ii,jj-1) cost_grid(ii-1,jj) cost_grid(ii-1,jj-1)]);
        cost_grid(ii,jj) = local_dis + global_minimum;
    end
end
final_cost = cost_grid(size(yy,1), size(xx,1));
end
end