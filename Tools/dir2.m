function listing = dir2(name)
    if nargin == 0
        name = '.';
    end

    if isfolder(name)
        name = fullfile(name, '*');
    end

    listing = dir(name);

    inds = [];
    n = 0;
    k = 1;

    while n < 2 && k <= length(listing)
        if any(strcmp(listing(k).name, {'.', '..'}))
            inds(end + 1) = k;
            n = n + 1;
        end
        k = k + 1;
    end

    listing(inds) = [];
end
