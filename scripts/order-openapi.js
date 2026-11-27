import { readFileSync, writeFileSync } from 'fs';
import { parseDocument } from 'yaml';

// The emitter sorts paths alphabetically. Keep the course list before the other
// Courses operations for documentation, preserving the original YAML formatting.
export function orderOpenApiOperations(filePath) {
  const source = readFileSync(filePath, 'utf8');
  const document = parseDocument(source);
  if (document.errors.length) {
    throw new Error(`Cannot order OpenAPI operations: ${document.errors[0].message}`);
  }
  const paths = document.get('paths');
  if (!paths) return;

  const listIndex = paths.items.findIndex(
    (entry) => entry.value.get('get')?.get('operationId') === 'CoursesV2_getCourses',
  );
  const firstCourseIndex = paths.items.findIndex((entry) =>
    entry.value.items.some((operation) =>
      operation.value.get?.('tags')?.items.some((tag) => tag.value === 'Courses'),
    ),
  );
  if (listIndex < 0 || firstCourseIndex < 0 || listIndex <= firstCourseIndex) return;

  const lineStart = (index) => source.lastIndexOf('\n', paths.items[index].key.range[0]) + 1;
  const start = lineStart(listIndex);
  const end = listIndex + 1 < paths.items.length
    ? lineStart(listIndex + 1)
    : paths.items[listIndex].value.range[2];
  const insertion = lineStart(firstCourseIndex);
  const reordered = source.slice(0, insertion)
    + source.slice(start, end)
    + source.slice(insertion, start)
    + source.slice(end);
  writeFileSync(filePath, reordered);
}
