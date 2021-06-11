<div wire:poll>
    <div class="flex flex-col px-8 mx-auto my-6 lg:flex-row max-w-7xl xl:px-5">
        <div class="flex flex-col justify-start flex-1 mb-5 overflow-hidden bg-white border rounded-lg lg:mr-3 lg:mb-0 border-gray-150">
            <div class="flex flex-wrap items-center justify-between p-5 bg-white border-b border-gray-150 sm:flex-no-wrap">
                <div class="flex items-center justify-center w-12 h-12 mr-5 rounded-lg bg-wave-100">
                    <svg class="w-6 h-6 text-wave-500" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
                <div class="relative flex-1">
                    <h3 class="text-lg font-medium leading-6 text-gray-700">
                        Add a new server to increase the capacity of your custer
                    </h3>
                    <p class="text-sm leading-5 text-gray-500 mt">
                        Usually takes about 5 minutes to fully provision a new server and add it to your Syntropy network
                    </p>
                </div>
                <span class="inline-flex mt-5 rounded-md shadow-sm">
                    <button wire:click="watchLog" class="inline-flex items-center px-3 py-2 text-sm font-medium leading-4 text-white transition duration-150 ease-in-out border border-gray-300 rounded-md bg-wave-500 hover:text-gray-200 focus:outline-none focus:border-blue-300 focus:shadow-outline-blue active:bg-gray-50">
                        Add a new server
                    </button>
                </span>
            </div>
            <div class="relative p-5">
                <div class="text-base leading-loose text-gray-500">
                    <pre>To do...</pre>
                </div>
            </div>
        </div>

    </div>
</div>
