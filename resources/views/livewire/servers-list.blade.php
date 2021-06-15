<div wire:poll="getServers">
    <div class="flex flex-col px-8 mx-auto my-6 lg:flex-row max-w-7xl xl:px-5">
        <div class="flex flex-col justify-start flex-1 mb-5 overflow-hidden bg-white border rounded-lg lg:mr-3 lg:mb-0 border-gray-150">
            <div class="flex flex-wrap items-center justify-between p-5 bg-white border-b border-gray-150 sm:flex-no-wrap">
                <div class="flex items-center justify-center w-12 h-12 mr-5 rounded-lg bg-wave-100">
                    <svg class="w-6 h-6 text-wave-500" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
                <div class="relative flex-1">
                    <h3 class="text-lg font-medium leading-6 text-gray-700">
                        Welcome to your Minecraft Server Manager Dashboard
                    </h3>
                    <p class="text-sm leading-5 text-gray-500 mt">
                        Your BungeeCord Proxy is running on <strong class="text-strong">{{ $proxyServer }}:25577</strong>
                    </p>
                    <p class="text-sm leading-5 text-gray-500 mt">
                        Here is a list of all of your servers:
                    </p>
                </div>
            </div>
            <div class="relative p-5">
                <div class="text-base leading-loose text-gray-500">
                    @if(!empty($log))
                        <pre class="scrollbar-none overflow-x-auto p-6 text-sm leading-snug language-html text-white bg-black bg-opacity-75">{{ $log }}</pre>
                    @endif
                </div>
            </div>
            <div class="relative p-5">
                <div class="text-base leading-loose text-gray-500">
                    @if(count($servers) == 1)
                    <div class="relative flex-1 text-center mb-6">
                        <h3 class="text-md font-medium leading-6 text-gray-700">
                            You don't have any servers yet!<br> Hit the `Add a new server` button bellow to create a server!
                    </div>
                    @else
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th scope="col"
                                        class="px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-500 uppercase">
                                        Server Name
                                    </th>
                                    <th scope="col"
                                        class="px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-500 uppercase">
                                        Server IP
                                    </th>
                                    <th scope="col"
                                        class="px-6 py-3 text-xs font-medium tracking-wider text-left text-right text-gray-500 uppercase">
                                        Actions
                                    </th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                @foreach ($servers as $name => $server)
                                    @if($server['address'] != 'localhost:25565')
                                        <tr>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-sm text-gray-900">{{ $name}}</div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-sm text-gray-900">{{ $server['address'] }}</div>
                                            </td>
            
                                            <td class="px-6 py-4 text-sm font-medium text-right content-end whitespace-nowrap">
                                                @if($locked == false)
                                                    <button wire:click="removeServer('{{ $name }}')" class="text-indigo-600 hover:text-indigo-900">Delete</button>
                                                @else
                                                    <a class="font-thin" style="cursor: wait;">Delete</a>
                                                @endif
                                            </td>
                                        </tr>
                                    @endif
                                @endforeach
                            </tbody>
                        </table>
                    @endif
                </div>
            </div>
        </div>
    </div>

</div>

