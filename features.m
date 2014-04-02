function [labels,values,u] = features(folder,bl,win)
  label_set = {'a','d','f','h','n','sa','su'};
  labels = [];
  values = [];
  for subject = dir(folder)'
    if subject.isdir && ~(strcmp(subject.name,'.')||strcmp(subject.name,'..'))
      for l = 1:numel(label_set)
        for file = dir([folder,'/',subject.name,'/',label_set{l},'*.wav'])'
          [d,sr] = wavread([folder,'/',subject.name,'/',file.name]);
          f = PitchTimeZeroCrossings(d,win*sr,bl*sr,sr);
          p = rastaplp(d,sr,1,12,'wintime',win,'hoptime',bl);
          m = mfcc(d,sr,1/bl);
          
          max_len = min([size(f,2),size(p,2),size(m,2)]);
          sample = [f(:,1:max_len); p(:,1:max_len); m(:,1:max_len)];
          sample = sample(:,isfinite(sample(1,:)));
          values = [values; sample'];
          
          new_labels = zeros(size(sample,2),7);
          new_labels(:,l) = 1;
          
          labels = [labels;  new_labels];
          
        end
      end
    end
  end
  
  [center,u,o] = fcm(values,10);

end