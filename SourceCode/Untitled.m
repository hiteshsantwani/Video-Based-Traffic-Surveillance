S = load('numveh.mat')
for f = fieldnames(S)
   disp(['Field named: ' f{1} ]);
   disp('Has value ')
   disp(S.(f{1}))
   
end
M = max(S.(f{1}))
   
   disp(M)
   
