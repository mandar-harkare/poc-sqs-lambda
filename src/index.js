/*
 * Copyright (C) 2018 Forcepoint
 */

module.exports.update = async (event) => {
  event.Records.forEach((record) => {
    // eslint-disable-next-line security/detect-object-injection
    console.log(`M<essage received: ${record}`);
  });
};
