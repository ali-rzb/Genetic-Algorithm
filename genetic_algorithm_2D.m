clear
clc
cities=10;
% X=rand(cities,2);
X = [50,90;
    80,80;
    90,70;
    80,50;
    75,30;
    75,25;
    20,20;
    30,80;
    40,85;
    45,87];

chromosome_number = 400;
chromosome = zeros(chromosome_number,cities);
for i=1:chromosome_number
    chromosome(i,:)=randperm(cities,cities);
end

Superior = chromosome(1,:);
Superior_Cost = 0;

output=zeros(50,2);
for y=1:2000
    
    cost=zeros(chromosome_number,1);
    for i=1:chromosome_number
        if i==50
           error = 'out of range' 
        end
        cost(i,1)=0;
        for j=1:cities-1
            p1=[X(chromosome(i,j),1),X(chromosome(i,j),2)];
            p2=[X(chromosome(i,j+1),1),X(chromosome(i,j+1),2)];
            dist = pdist( [p1;p2] ,'euclidean');
            
            cost(i,1)=cost(i,1) + dist;
        end 
        cost(i,1)=cost(i,1)+pdist([X(chromosome(i,cities),1),X(chromosome(i,cities),2);X(chromosome(i,1),1),X(chromosome(i,1),2)],'euclidean');
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
        grid on
        final=[X( chromosome(I(1),:),1),X( chromosome(I(1),:),2)];
        final=vertcat(final,[X( chromosome(I(1),1),1),X( chromosome(I(1),1),2)]);
        fig=plot(final(:,1),final(:,2));
        title(strcat(string(sorted_cost(1)),'@',string(y)));
        fpath = 'pic';
        saveas(fig, fullfile(fpath, strcat(string(y),'a')), 'png');
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






