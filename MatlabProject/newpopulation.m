function newpopulation = newpopulation(chromosome, offspring)
    numChromosome=size(chromosome,2);
    numOffspring=size(offspring,2);
    wholePopulationSize=numChromosome+numOffspring;
    fitarray=zeros([1 wholePopulationSize]);
    %Πίνακας που περιέχει την προσαρμογή της παλιάς και της νέας γενιάς
    for i=1:numChromosome
        fitarray(i)=chromosome{i}.fit;
    end
    for i=1:numOffspring
        fitarray(numChromosome+i)=offspring{i}.fit;
    end
    %Εύρεση καλύερων χρωμοσωμάτων για την νέα γενιά
    [~,newPopulationIndices]=sort(fitarray,"descend");
    newpopulation=cell(1,numChromosome);
    for i=1:numChromosome
        if newPopulationIndices(i)<=numChromosome
            newpopulation{i}=chromosome{newPopulationIndices(i)};
        else 
            newpopulation{i}=offspring{newPopulationIndices(i)-numChromosome};
        end
    end
end
