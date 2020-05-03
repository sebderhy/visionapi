const APP_NAME = "Vision API Demo";

class Model {
  const Model(this.name, this.path);
  final String name;
  final String path;
}

List<Model> modelsList = <Model>[
  const Model('Background Segmentation', 'binseg-3'),
  const Model('Super-resolution', 'superres-2b'),
  const Model('Style Transfer 1', 'styletransf-1'),
  const Model('Style Transfer 2', 'styletransf-2'),
  const Model('Style Transfer 3', 'styletransf-3'),
  const Model('Semantic Segmentation', 'semseg-3'),
  const Model('Depth', 'depth-bts'),
];

const STATUS_WAIT = 0;
const STATUS_IMAGE_LOADED = 1;
const STATUS_FINISHED = 2;
