function [labels,values] = average_features(folder,bl,win)
  label_set = {'a','d','f','h','n','sa','su'};
  labels = [];
  values = [];
  for subject = dir(folder)'
    if subject.isdir && ~(strcmp(subject.name,'.')||strcmp(subject.name,'..'))
      for l = 1:numel(label_set)
        for file = dir([folder,'/',subject.name,'/',label_set{l},'*.wav'])'
          [d,sr] = wavread([folder,'/',subject.name,'/',file.name]);
          f = PitchTimeZeroCrossings(d,win*sr,bl*sr,sr);
          r = energy(d,win,bl,sr);
          p = rastaplp(d,sr,1,12,'wintime',win,'hoptime',bl);
          m = mfcc(d,sr,1/bl);
          
          max_len = min([size(f,2),size(r,2),size(p,2),size(m,2)]);
          sample = [f(:,1:max_len); r(:,1:max_len); p(:,1:max_len); m(:,1:max_len)];
          sample = sample(:,isfinite(sample(1,:)))';
          
          values = [values; [mean(sample) var(sample)]];
          
          new_labels = zeros(1,7);
          new_labels(:,l) = 1;
          
          labels = [labels;  new_labels];
          
        end
      end
    end
  end
  
  mx=repmat(max(values,[],1),size(values,1),1);
  mn=repmat(min(values,[],1),size(values,1),1);
  values = (values-mn)./(mx-mn);

end

function r = energy(d,window,block,sr)
  window_length = window*sr;
  block_length = block*sr;
  num_blocks = ceil(length(d)/block_length);
  
  r = zeros(1,num_blocks);
  
  for i = 1:num_blocks
    i_start = (i-1)*block_length + 1;
    i_stop = min(length(d),i_start + window_length - 1);
    sample = d(i_start:i_stop);
    r(i) = sqrt(sum(sample.^2));
  end
  
end