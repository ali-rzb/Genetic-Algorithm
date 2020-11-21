clear
clc
cities=19;
% X=rand(cities,2);

X = [0    0.8768    0.4175    0.9000    0.3133    0.3421    0.6644    0.3593    0.6485    0.4280    0.3206    0.6480    0.7055    0.7240    0.7919    0.0194    0.7596    0.0838   0.2943
;0    0.9446    0.0484    0.5226    0.4151    0.7339    0.7846    0.2425    0.8011    0.5335    0.5340    0.9972    0.8057    0.1968    0.3253    0.4630    0.4941    0.5326   0.0001
;0    0.5235    0.6037    0.9596    0.2854    0.7313    0.1083    0.5833    0.7506    0.3325    0.0963    0.1325    0.6265    0.9403    0.2167    0.1819    0.0297    0.9780   0.2045] ;
X=X.';

chromosome_number = 1000;
chromosome = zeros(chromosome_number,cities);
for i=1:chromosome_number
    chromosome(i,:)=randperm(cities,cities);
end

Superior = chromosome(1,:);
Superior_Cost = 0;

output=zeros(50,2);
for y=1:1000
    
    cost=zeros(chromosome_number,1);
    for i=1:chromosome_number
        
        cost(i,1)=0;
        for j=1:cities-1
            p1=[X(chromosome(i,j),1),X(chromosome(i,j),2),X(chromosome(i,j),3)];
            p2=[X(chromosome(i,j+1),1),X(chromosome(i,j+1),2),X(chromosome(i,j+1),3)];
            dist = pdist( [p1;p2] ,'euclidean');
            
            cost(i,1)=cost(i,1) + dist;
        end 
        
        p1=[X(chromosome(i,cities),1),X(chromosome(i,cities),2),X(chromosome(i,cities),3)];
        p2=[X(chromosome(i,1),1),X(chromosome(i,1),2),X(chromosome(i,1),3)];
        cost(i,1)=cost(i,1)+pdist([p1;p2],'euclidean');
    end

    if(y==1)
        Superior_Cost = cost(1);
    end
    
    
    output(y,1)=cost(1);
    output(y,2)=y;
    
    
    
    [sorted_cost,I]=sort(cost);
    
    
    
    
    if (sorted_cost(1)<Superior_Cost) || (y == 1)
        Superior_Cost=sorted_cost(1);
        Superior=chromosome(I(1),:);
        final=[X( chromosome(I(1),:),1),X( chromosome(I(1),:),2),X( chromosome(I(1),:),3)];
        final=vertcat(final,[X( chromosome(I(1),1),1),X( chromosome(I(1),1),2),X( chromosome(I(1),1),3)]);
        fig=plot3(final(:,1),final(:,2),final(:,3));
        grid on
        title(strcat(string(sorted_cost(1)),'@',string(y)));
        saveas(fig,strcat('pic/',string(y),'a.png'));   
    end
    
    
    third_of_chromosome_number =int64(chromosome_number/3);
    
    for mutation_i=1:third_of_chromosome_number
        
        rand_mutation_cities=randperm(cities,2);
        temp=chromosome( mutation_i , rand_mutation_cities(1) );
        chromosome(mutation_i,rand_mutation_cities(1))=chromosome(mutation_i,rand_mutation_cities(2));
        chromosome(mutation_i,rand_mutation_cities(2))=temp;    
    end
    for mutation_i=(third_of_chromosome_number:1:third_of_chromosome_number*2)
        n=randi(cities-1);
        chromosome( mutation_i , : ) = [ chromosome( mutation_i , n+1:cities) , flip( chromosome(mutation_i,1:n)) ]; 
    end
end  






