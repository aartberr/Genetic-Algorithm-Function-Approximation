%Mutation: Τυχαία μετάλλαξη
function mutatedOffspring=mutate(offspring, mutationRate)
    numOffspring=size(offspring,2);
    mutatedOffspring=cell(1,numOffspring);
    for i=1:numOffspring
        mutatedOffspring{i}=offspring{i};
        componentSize=size(offspring{1}.data,1);
        numParameters=size(offspring{1}.data,2);
        %Αν mutation=1 (πιθανότητα=mutationRate) αλλαγή παραμέτρου,αν
        %mutation=0 (πιθανότητα=1-mutationRate) δεν αλλάζει
        mutation=rand([componentSize numParameters])< mutationRate;
        %Τα βάρη δεν μεταλλάσονται
        mutation(:,1)=0;
        %Μέγεθος αλλαγής κάθε συνιστώσας
        mutationValues=rand([componentSize numParameters])*0.2-0.1;
        %Διαδικαία μετάλλαξης
        mutatedOffspring{i}.data=mutatedOffspring{i}.data+mutation.*mutationValues;
        mutatedOffspring{i}.fit=evaluateFitness(mutatedOffspring{i});
    end
end