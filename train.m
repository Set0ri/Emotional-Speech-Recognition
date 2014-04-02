function train(labels,values)
  cutoff = 5000;
  K = 10;
  shuffle = randperm(size(labels,1));
  shuffle = shuffle(1:cutoff);
  labels = labels(shuffle,:);
  values = values(shuffle,:);
 
  [center,u,o] = fcm(values,10);
  
  indices = crossvalind('Kfold',cutoff,K);
  [m,class] = max(labels,[],2);
  cp = classperf(class);
  for i = 1:K
    test = (indices == i); train = ~test;
    net = newrbe(u(:,train),labels(train,:)');
    y = sim(net,u(:,test));
    [m,class] = max(y,[],1);
    classperf(cp,class,test);
  end
  
  cp.ErrorRate

end