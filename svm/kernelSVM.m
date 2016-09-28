function [] = kernelSVM( )

%Load Data
%load artificial.mat

%svmtoy(Y, data, '-t 2 -g 10000', [0 0]);

load dataset2.mat
half = size(Y,1)/2 ;

mdl1 = svmtrain(Y(1:half,:), data(1:half, :), '-t 2 -g 1000 -v 10');
mdl2 = svmtrain(Y(half+1:end,:), data(half+1:end, :), '-t 2 -g 1000 -v 10');

%[test_label2 test_acc2] = svmpredict(Y(half+1:end, :), data(half+1:end, :), mdl1);
%[test_label1 test_acc1] = svmpredict(Y(1:half, :), data(1:half, :), mdl2);

(mdl1 + mdl2)/2

%(test_acc2 + test_acc1)/2 

end

