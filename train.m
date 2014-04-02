function [best_net,best_rate,skill_matrix] = train(labels,values)
  cutoff = 5000;
  K = 10;
  shuffle = randperm(size(labels,1));
  shuffle = shuffle(1:cutoff);
  labels = labels(shuffle,:);
  values = values(shuffle,:);
  
  clusters = [2,4,8,16];
  spread = [0.01,0.1,1,10];
  
  skill_matrix = zeros(length(clusters),length(spread));
  best_rate = 0;
  
 
  for c_num = 1:length(clusters)
      [center,u,o] = fcm(values,clusters(c_num));

      for spr_num = 1:length(spread)
          indices = crossvalind('Kfold',cutoff,K);
          [m,class] = max(labels,[],2);
          cp = classperf(class);
          for i = 1:K
            test = (indices == i); train = ~test;
            net = newrbe(u(:,train),labels(train,:)',spread(spr_num));
            y = sim(net,u(:,test));
            [m,class] = max(y,[],1);
            classperf(cp,class,test);
          end

          skill_matrix(c_num,spr_num) = cp.CorrectRate;
          if cp.CorrectRate > best_rate
             best_rate = cp.CorrectRate
             best_net = net;
          end
      end
  
  end

end