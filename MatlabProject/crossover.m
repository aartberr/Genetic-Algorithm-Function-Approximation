%Crossover: Διακριτή διασταύρωση
function offspring=crossover(parents)
    numParents=size(parents,2);
    componentSize=size(parents{1}.data,1);
    numParameters=size(parents{1}.data,2);
    %Τυχαία επιλογή ζευγαριού γονέων
    perm=randperm(numParents)';
    parentIndices=[perm(1:numParents/2) perm(numParents/2+1:numParents)];
    offspring=cell(1,numParents/2);
    for i=1:numParents/2
        parent1=parents{parentIndices(i,1)};
        parent2=parents{parentIndices(i,2)};
        %Για κάθε παράμετρο πόσα στοιχεία θα κληρονομήσει από κάθε γονέα
        crossoverPoint=randi(componentSize,[1 numParameters]);
        for j=1:numParameters
          offspring{i}.data(:,j)=[parent1.data(1:crossoverPoint(j),j); parent2.data(crossoverPoint(j)+1:end,j)];
        end
        %Αν όλα τα βάρη προκύψουν να έιναι 0 τότε θα πάρει τα βάρη 
        %από τον καλύτερο γονέα
        if offspring{i}.data(:,1)==0
            if parent1.fit>=parent2.fit
                offspring{i}.data(:,1)=parent1.data(:,1);
            else
                offspring{i}.data(:,1)=parent2.data(:,1);
            end
        end
        offspring{i}.fit=evaluateFitness(offspring{i});
    end
end