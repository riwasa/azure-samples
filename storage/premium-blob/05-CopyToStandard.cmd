rem *****************************************************************************
rem
rem File:        05-CopyToStandard.cmd
rem 
rem Description: Copies files to the Standard Storage Account.
rem
rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
rem IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
rem FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
rem AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
rem LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
rem OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
rem SOFTWARE.
rem 
rem *****************************************************************************

azcopy /source:. /Dest:https://rimdemopbstdlrs.blob.core.windows.net/uploads/ /DestKey:KZ90RZSH55mnu6ViaAp0idHjNsdPVHT9eNw/Dee2wMh2M+51UUIBkF3gzUfKUH0/IXP90Poz7yAvmlz8tVS85A== /Pattern:*.pptx /V:stdlog.txt /BlobType:Block
azcopy /source:. /Dest:https://rimdemopbprem2.blob.core.windows.net/uploads/ /DestKey:QUWDUY450GlBnrBIW1wGftUaUTD0IgIf7tgZ6imFl41Rh0VVU2xWdnABs6QeFu7HUV+uekpMDgOuYwaoOQAf8g== /Pattern:*.pptx /V:premlog.txt /BlobType:Block
