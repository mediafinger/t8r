# source: https://gist.github.com/potatosalad/760726

class Object
  # expects [ [ symbol, *args ], ... ]
  def recursive_send(*args)
    args.inject(self) { |obj, m| obj.send(m.shift, *m) }
  end
end

class Hash
  # auto creates children
  # from: http://rubyworks.github.com/facets/doc/api/core/Hash.html
  def self.autonew(*args)
    leet = lambda { |hsh, key| hsh[key] = new( &leet ) }
    new(*args,&leet)
  end

  def explode(divider = '.')
    h = Hash.autonew
    for k,v in self.dup
      tree = k.to_s.split(divider).map { |x| [ :[], x ] }
      tree.push([ :[]=, tree.pop[1], v ])
      h.recursive_send(*tree)
    end
    h
  end

  def implode(divider = '.')
    h = Hash.new
    self.dup.each_path(divider) do |path, value|
      h[path] = value
    end
    h
  end

  # each_path method for multi-dimensional Hash
  # from: http://snippets.dzone.com/posts/show/3565
  def each_path(divider = '.')
    raise ArgumentError unless block_given?
    self.class.each_path(self, '', divider) { |path, object| yield path, object }
  end

protected
  def self.each_path(object, path = '', divider = '.', &block)
    if object.is_a?(Hash)
      object.each do |key, value|
        self.each_path value, "#{path}#{path.empty? ? '' : divider}#{key}", divider, &block
      end
    else
      yield path, object
    end
  end
end
