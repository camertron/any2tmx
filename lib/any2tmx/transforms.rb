module Any2Tmx
  module Transforms
    autoload :AndroidTransform, 'any2tmx/transforms/android_transform'
    autoload :JsonTransform,    'any2tmx/transforms/json_transform'
    autoload :Transform,        'any2tmx/transforms/transform'
    autoload :Result,           'any2tmx/transforms/result'
    autoload :YamlTransform,    'any2tmx/transforms/yaml_transform'
  end
end
