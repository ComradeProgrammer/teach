import Transform from '../../tools/transform'

class Label {
  constructor() {
    this.id = '';
    this.iid = '';
    this.projectId = null;

    this.title = '';
    this.projectName = '';

    this.color = '#5843ad';
    this.description = '';

    this.author = null;

    this.createdAt = null;
    this.updatedAt = null;
    this.dueDate = null;
  }

  static valueOf(obj) {
    let res = new Label();

    for (let key in obj) {
      let camelKey = Transform.toCamelCase(key);
      if (res[camelKey] !== undefined) {
        res[camelKey] = obj[key];
      }
    }
    return res;
  }

  toObj() {
    const obj = {};
    for (let key in this) {
      let underLine = Transform.toUnderLine(key);
      obj[underLine] = this[key];
    }
    return obj;
  }
}

export default Label;
