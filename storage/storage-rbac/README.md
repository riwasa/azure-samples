# storage-rbac

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

This folder contains templates and scripts for creating a Storage Account and assigning roles.

| Filename | Description |
| -------- | ----------- |
| storage.ps1 | PowerShell script for calling storage.bicep. |
| storage.bicep | Bicep template for creating a Storage Account. |
| storage.parameters.json | Parameters for storage.bicep. |
| storage-rbac.bicep | Bicep module for assigning storage roles to a principal. |

