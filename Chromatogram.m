clear; clc; cla; clf

[sampleStruct, probStruct, Comments] = scfread('sample.scf');
% figure
% hold on
% plot(sampleStruct.A);
% plot(sampleStruct.C);
% plot(sampleStruct.G);
% plot(sampleStruct.T);

% legend('A','C','G','T');

newSampleStructA = removeNoise(sampleStruct.A);
newSampleStructC = removeNoise(sampleStruct.C);
newSampleStructG = removeNoise(sampleStruct.G);
newSampleStructT = removeNoise(sampleStruct.T);
figure;
hold on;
plot(newSampleStructA);
plot(newSampleStructC);
plot(newSampleStructG);
plot(newSampleStructT);
legend('A (Filtered)', 'C (Filtered)', 'G (Filtered)', 'T (Filtered)');


function newSampleStruct = removeNoise(sampleData)
    startPoint = 1;
    trimThreshold = mean(sampleData) * 0.1;

    for i = 1:length(sampleData)
        if sampleData(i) > trimThreshold
            startPoint = i;
            break;
        end
    end
    
    sampleData = sampleData(startPoint:end);

    x = 1:length(sampleData);
    x = x';

    thresholdValue = mean(sampleData) * 0.7;
    noiseIndices = find(sampleData < thresholdValue);
    noiseValues = sampleData(noiseIndices);

    p = polyfit(noiseIndices, noiseValues, 5);
    noiseThreshold = polyval(p, x);

    newSampleStruct = sampleData - noiseThreshold;

    newSampleStruct(newSampleStruct < 0) = 0;
end
