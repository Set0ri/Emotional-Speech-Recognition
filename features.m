function [labels,values] = features(folder,bl,win)
  labels = {'a','d','f','h','n','sa','su'};
  values = {[],[],[],[],[],[],[]};
  for subject = dir(folder)'
    if subject.isdir && ~(strcmp(subject.name,'.')||strcmp(subject.name,'..'))
      for l = 1:numel(labels)
        for file = dir([folder,'/',subject.name,'/',labels{l},'*.wav'])'
          [d,sr] = wavread([folder,'/',subject.name,'/',file.name]);
          f = PitchTimeZeroCrossings(d,win*sr,bl*sr,sr);
          p = rastaplp(d,sr,1,12,'wintime',win,'hoptime',bl);
          m = mfcc(d,sr,1/bl);
          
          max_len = min([size(f,2),size(p,2),size(m,2)]);
          sample = [f(:,1:max_len); p(:,1:max_len); m(:,1:max_len)];
          sample = sample(:,isfinite(sample(1,:)));
          values{l} = [values{l}; sample'];
        end
      end
    end
  end

end